import Foundation
import UIKit
import CoreML

class YOLO {
    var inputWidth = 416
    var inputHeight = 416
    var maxBoundingBoxes = 20
    var numClasses = 1
    
    var labels : [String] = []
    
    // Tweak these values to get more or fewer predictions.
    var confidenceThreshold: Float = 0.6
    var iouThreshold: Float = 0.5
    
    struct Prediction {
        let classIndex: Int
        let name: String?
        let score: Float
        let rect: CGRect
    }
    var predictionsFE: [Prediction] = []

    var model : yolo_model?
    public init() { }
    
    public func predict(image: CVPixelBuffer) throws -> [Prediction] {
        if let output = try? model?.prediction(inputs: image) {
            return computeBoundingBoxes(features: output.predictions)
        } else {
            return []
        }
    }
    
    let theURL = URL(string:"http://10.0.1.137:8888/predict?score_threshold=0.5&iou_threshold=0.5")
    public func getBBsFromAPI(image: UIImage, imagew: CGFloat, imageh: CGFloat) throws -> [Prediction] {
        // Asynchronous Http call to your api url, using URLSession:
        //guard let imageData = imageData else { return []}
        let boundary = UUID().uuidString

        //let session = URLSession(configuration: .default)
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: theURL!)
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        // Add the image data to the raw http request data
        //data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"testImage.png\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        
        //data.append(image.jpegData(compressionQuality: 0.9)!)
        data.append(image.pngData()!)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        urlRequest.httpBody = data
        
//  For reference
//        struct Prediction {
//            let classIndex: Int
//            let score: Float
//            let rect: CGRect
//        }

        // Add a semaphore here to wait on completion
        let inferenceQuerySemaphore = DispatchSemaphore(value: 0)
        // Send a POST request to the URL, with the data we created earlier
        dataTask = defaultSession.dataTask(with: urlRequest, completionHandler: { responseData, response, error in
            if error == nil {
                
                self.predictionsFE.removeAll() // make sure its empty
                if let responseData = responseData,
                   let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String:Any] {
                    let p = json["predictions"] as? [Any]
                    let len = p?.count
                    if len ?? 0 > 0 {
                        for i in 0...(len ?? 1)-1 {
//                            print("i is ",i)
                            let thisp = p?[i] as? [String:Any]
//                            print("gogogo")
//                            print(thisp)
//                            print("sososo")
//                            print(thisp?["bbox"])
                            let bbox = thisp?["bbox"] as? [Any]
//                            print("bbbbb")
//                            print(bbox)
                            let x = (bbox?[0] as? NSNumber)?.floatValue ?? 0
                            let y = (bbox?[1] as? NSNumber)?.floatValue ?? 0
                            let x2 = (bbox?[2] as? NSNumber)?.floatValue ?? 0
                            let y2 = (bbox?[3] as? NSNumber)?.floatValue ?? 0
                            let gcx = CGFloat(x) * CGFloat(self.inputWidth) //* imagew
                            let gcy = CGFloat(y) * CGFloat(self.inputHeight)//* imageh
                            let gcw = CGFloat(x2) * CGFloat(self.inputWidth) - gcx
                            let gch = CGFloat(y2) * CGFloat(self.inputHeight) - gcy
                            
                            let score = thisp!["confidence"] as! Float
                            let name = thisp!["name"] as! String
                            let rect = CGRect(x: gcx, y: gcy, width: gcw, height: gch)
                            let pred = Prediction(classIndex: 0, name: name, score: score, rect: rect)
                            self.predictionsFE.append(pred)
                        }
                    }
                }
            }
            else {
                print(error)
            }
            inferenceQuerySemaphore.signal()
            print("inferenceQuerySemaphore.signal")
        })
        
        dataTask?.resume()
        inferenceQuerySemaphore.wait()
        print("inferenceQuerySemaphore.wait")
        return self.predictionsFE
    }
    

    
    public func computeBoundingBoxes( features: MLMultiArray) -> [Prediction] {
        var predictions = [Prediction]()
        
        let increment = numClasses+5
        let total_bbox = (features.count) / (numClasses + 5)
        
        for j in 0..<total_bbox {
            
            let tx = Float(truncating: features[0+(increment*j)])
            let ty = Float(truncating: features[1+(increment*j)])
            let tw = Float(truncating: features[2+(increment*j)])
            let th = Float(truncating: features[3+(increment*j)])
            
            let tc = Float(truncating: features[4+(increment*j)])
            let confidence = sigmoid(tc)
            
            var class_probs = [Float](repeating: 0, count: numClasses)
            
            for c in 0..<numClasses {
                class_probs[c] = Float(truncating: features[5+c+(increment*j)])
            }
            
            let (detectedClass, bestClassScore) = class_probs.argmax()

            let confidenceInClass = bestClassScore * confidence
            
            if confidenceInClass >= confidenceThreshold {
                let rect = CGRect(x: CGFloat(tx)  - (CGFloat(tw)/2), y: CGFloat(ty) - (CGFloat(th)/2),
                                  width: CGFloat(tw), height: CGFloat(th))
                
                let prediction = Prediction(classIndex: detectedClass,name:"", score:    confidenceInClass,rect: rect)
                predictions.append(prediction)
            }
        }
        
        // We already filtered out any bounding boxes that have very low scores,
        // but there still may be boxes that overlap too much with others. We'll
        // use "non-maximum suppression" to prune those duplicate bounding boxes.
        
        
        return  nonMaxSuppression(boxes: predictions, limit: maxBoundingBoxes, threshold: iouThreshold)
        
    }
    
}

