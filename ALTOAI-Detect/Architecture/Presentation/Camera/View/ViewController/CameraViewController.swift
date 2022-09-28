import UIKit
import AVFoundation
import CoreMedia
import VideoToolbox
import ZIPFoundation
import RandomColorSwift

final class CameraViewController: UIViewController, UIDocumentPickerDelegate {
    
    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var fpsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var debugImageView: UIImageView!
    @IBOutlet weak var slidersVisibilityButton: UIButton!
    @IBOutlet weak var slidersView: UIView!
    @IBOutlet weak var confidenceSlider: UISlider!
    @IBOutlet weak var confidenceValueLabel: UILabel!
    @IBOutlet weak var iouSlider: UISlider!
    @IBOutlet weak var iouValueLabel: UILabel!
    
    var storeImage = true
    
    var yolo = YOLO()
    let group = DispatchGroup()
    let queue = DispatchQueue.global(qos: .userInteractive)

    var inflightBuffer = 0
    static let maxInflightBuffers = 2
    let semaphore = DispatchSemaphore(value: CameraViewController.maxInflightBuffers)
    
    var frame_num = 0
    var videoCapture: VideoCapture!
    
    var boundingBoxes = [BoundingBox]()
    var predictionsFE: [Prediction] = []
    var colors: [UIColor] = []
    
    let ciContext = CIContext()
    var resizedPixelBuffer: CVPixelBuffer?
    
    var framesDone = 0
    var frameCapturingStartTime = CACurrentMediaTime()
    
    
    var edgeComputingUrl: String?
    var semaphoreCounter = 1
    var inferenceType: InferenceType = .local
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = ""
        fpsLabel.text = ""
        configureSlider()
        setUp()
        frameCapturingStartTime = CACurrentMediaTime()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let videoCapture = videoCapture else { return }
        videoCapture.stopCapture()
        super.viewWillDisappear(animated)
        semaphore.signal()
    }
    
    func setUp() {
        setUpBoundingBoxes()
        setUpCoreImage()
        setUpCamera()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function)
    }
    
    // MARK: - Initialization
    private func setUpBoundingBoxes() {
        boundingBoxes.forEach { boundingBox in
            boundingBox.shapeLayer.removeFromSuperlayer()
            boundingBox.textLayer.removeFromSuperlayer()
        }
        boundingBoxes.removeAll()
        for _ in 0..<yolo.maxBoundingBoxes {
            boundingBoxes.append(BoundingBox())
        }
        
        // Make colors for the bounding boxes. There is one color for each class,
        colors = randomColors(count: yolo.numClasses, luminosity: .light)
    }
    
    private func configureSlider() {
        confidenceSlider.value = yolo.confidenceThreshold
        confidenceValueLabel.text = "\(String(format: "%.2f", confidenceSlider.value))"
        iouSlider.value = yolo.iouThreshold
        iouValueLabel.text = "\(String(format: "%.2f", iouSlider.value))"
    }
    
    private func setUpCoreImage() {
        let status = CVPixelBufferCreate(nil, yolo.inputWidth, yolo.inputHeight, kCVPixelFormatType_32BGRA, nil, &resizedPixelBuffer)
        if status != kCVReturnSuccess {
            print("Error: could not create resized pixel buffer", status)
        }
    }
    
    private func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 50
        let preset = UIDevice.current.userInterfaceIdiom == .pad ? AVCaptureSession.Preset.vga640x480 : AVCaptureSession.Preset.hd1280x720
        videoCapture.setUp(sessionPreset: preset) { [weak self] success in
            guard let self = self else { return }
            if success {
                // Add the video preview into the UI.
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                
                // Add the bounding box layers to the UI, on top of the video preview.
                for box in self.boundingBoxes {
                    box.addToLayer(self.videoPreview.layer)
                }
                
                // Once everything is set up, we can start capturing live video.
                self.videoCapture.startCapture()
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleSlidersPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.slidersView.alpha = self?.slidersView.alpha == 1.0 ? 0.0 : 1.0
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        if (sender == confidenceSlider) {
            confidenceValueLabel.text = "\(String(format: "%.2f", confidenceSlider.value))"
            yolo.confidenceThreshold = confidenceSlider.value
        } else  if (sender == iouSlider) {
            iouValueLabel.text = "\(String(format: "%.2f", iouSlider.value))"
            yolo.iouThreshold = iouSlider.value
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        resizePreviewLayer()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = videoPreview.bounds
    }
    
    // MARK: - Rotation Stuff
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        self.videoCapture.previewLayer?.connection?.videoOrientation = orientation
        self.videoCapture.videoOutput.connection(with: AVMediaType.video)?.videoOrientation = orientation
        self.videoCapture.previewLayer?.frame = self.view.bounds
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let connection =  self.videoCapture.previewLayer?.connection  {
            let currentDevice: UIDevice = UIDevice.current
            let orientation: UIDeviceOrientation = currentDevice.orientation
            let previewLayerConnection : AVCaptureConnection = connection
            if previewLayerConnection.isVideoOrientationSupported {
                switch (orientation) {
                case .portrait: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                case .landscapeRight: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
                case .landscapeLeft: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
                case .portraitUpsideDown: updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
                default: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                }
            }
        }
    }
}

// MARK: Implement methods
extension CameraViewController {
    func showOnMainThread(_ boundingBoxes: [Prediction], latency: CFTimeInterval) {
        DispatchQueue.main.async {
            self.showBoundingBoxes(predictions: boundingBoxes)
            self.timeLabel.text = String(format: "%.5f", latency)
            let fps = self.measureFPS()
            self.fpsLabel.text = String(format: "%.2f", fps)
        }
    }
    
    func measureFPS() -> Double {
        // Measure how many frames were actually delivered per second.
        framesDone += 1
        let frameCapturingElapsed = CACurrentMediaTime() - frameCapturingStartTime
        let currentFPSDelivered = Double(framesDone) / frameCapturingElapsed
        if frameCapturingElapsed > 1 {
            framesDone = 0
            frameCapturingStartTime = CACurrentMediaTime()
        }
        return currentFPSDelivered
    }
    
    // MARK: - Doing inference
    func predict(pixelBuffer: CVPixelBuffer) {
        // Measure how long it takes to predict a single video frame.
        let startTime = CACurrentMediaTime()
        guard let resizeImage = self.resizeImage(pixelBuffer: pixelBuffer) else { return }
        let inputImageWidth = CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let inputImageHeight = CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        

        switch self.inferenceType {
        case .local:
            self.semaphore.wait()
            self.saveImageToDisk(pixelBuffer: pixelBuffer, resizeImage: resizeImage)
            guard let resizedPixelBuffer = resizedPixelBuffer else { return }
            if let boundingBoxes = try? yolo.predict(image: resizedPixelBuffer) {
                let elapsed = CACurrentMediaTime() - startTime
                showOnMainThread(boundingBoxes, latency: elapsed)
            }
            self.semaphore.signal()
        case .edge:
            if semaphoreCounter <= 0 { return }
            self.edgeConnection(resizeImage: resizeImage, imageWidth: inputImageWidth, imageHeight: inputImageHeight, startTime: startTime)
        case .clound:
            if semaphoreCounter <= 0 { return }
            self.edgeConnection(resizeImage: resizeImage, imageWidth: inputImageWidth, imageHeight: inputImageHeight, startTime: startTime)
        }
    }
    
    private func edgeConnection(resizeImage: UIImage, imageWidth: CGFloat, imageHeight: CGFloat, startTime: CFTimeInterval) {
//        self.semaphore.wait()
        self.semaphore.wait()
        self.semaphoreCounter -= 1
        self.getBBsFromAPI(image: resizeImage, imagew: imageWidth, imageh: imageHeight, completionHandler: { [weak self] data, _, error in
            guard let self = self else { return }
            
            if error == nil {
                self.predictionsFE.removeAll()
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        let p = json["predictions"] as? [Any]
                        let len = p?.count
                        print("Predictions item: \(String(describing: len))")
                        if len ?? 0 > 0 {
                            for i in 0...(len ?? 1)-1 {
                                let thisp = p?[i] as? [String:Any]
                                let bbox = thisp?["bbox"] as? [Any]
                                let x = (bbox?[0] as? NSNumber)?.floatValue ?? 0
                                let y = (bbox?[1] as? NSNumber)?.floatValue ?? 0
                                let x2 = (bbox?[2] as? NSNumber)?.floatValue ?? 0
                                let y2 = (bbox?[3] as? NSNumber)?.floatValue ?? 0
                                let gcx = CGFloat(x) * CGFloat(416) //* imagew
                                let gcy = CGFloat(y) * CGFloat(416)//* imageh
                                let gcw = CGFloat(x2) * CGFloat(416) - gcx
                                let gch = CGFloat(y2) * CGFloat(416) - gcy
                                
                                let score = thisp!["confidence"] as! Float
                                let name = thisp!["name"] as! String
                                let rect = CGRect(x: gcx, y: gcy, width: gcw, height: gch)
                                let pred = Prediction(classIndex: 0, name: name, score: score, rect: rect)
                                self.predictionsFE.append(pred)
                            }
                        }
                    }
                    self.semaphore.signal()
                    self.semaphoreCounter += 1
                }
                print("Predictions: \(self.predictionsFE.count)")
                let elapsed = CACurrentMediaTime() - startTime
                self.showOnMainThread(self.predictionsFE, latency: elapsed)
            }  else {
                print(error.debugDescription)
            }
        })
    }
}

// MARK: VideoCaptureDelegate
extension CameraViewController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        if let pixelBuffer = pixelBuffer {
            self.predict(pixelBuffer: pixelBuffer)
        }
    }
}

extension CameraViewController {
    
    private func resizeImage(pixelBuffer: CVPixelBuffer) -> UIImage? {
        // Resize the input with Core Image to 416x416.
        guard let resizedPixelBuffer = resizedPixelBuffer else { return nil }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let sx = CGFloat(yolo.inputWidth) / CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let sy = CGFloat(yolo.inputHeight) / CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let scaleTransform = CGAffineTransform(scaleX: sx, y: sy)
        let scaledImage = ciImage.transformed(by: scaleTransform)
        ciContext.render(scaledImage, to: resizedPixelBuffer)
        
        let ciResizeImage = CIImage(cvPixelBuffer: resizedPixelBuffer)
        guard let cgResizeImage = ciContext.createCGImage(ciResizeImage, from: ciResizeImage.extent) else { return nil }
        return UIImage(cgImage: cgResizeImage)
    }
    
    private func saveImageToDisk(pixelBuffer: CVPixelBuffer, resizeImage: UIImage) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            if self.storeImage {
                let fileManager = FileManager.default
                
                let documentsDirectory = fileManager.urls(for: .documentDirectory,
                                                          in: .userDomainMask).first!
                // to get images of correct dimensions instead of 2x
                let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
                let ciContext = CIContext()
                guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else {return}
                let image = UIImage(cgImage: cgImage)
                //let image = UIImage(ciImage: CIImage(cvPixelBuffer: pixelBuffer))
                let fileName = "image_\(self.frame_num).png"
                // create the destination file url to save your image
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                // get your UIImage jpeg data representation and check if the destination file url already exists
                if self.frame_num % 50 == 0,
                   let data = image.pngData(),
                   !FileManager.default.fileExists(atPath: fileURL.path) {
                    do {
                        // writes the image data to disk
                        try data.write(to: fileURL)
                        print("file saved : \(fileURL)")
                    } catch {
                        print("error saving file:", error)
                    }
                }
                let resizefileName = "resize_image_\(self.frame_num).png"
                // create the destination file url to save your image
                let resizefileURL = documentsDirectory.appendingPathComponent(resizefileName)
                // get your UIImage jpeg data representation and check if the destination file url already exists
                let data = resizeImage.pngData()
                if self.frame_num % 50 == 0,
                   !FileManager.default.fileExists(atPath: resizefileURL.path) {
                    do {
                        // writes the image data to disk
                        try data!.write(to: resizefileURL)
                        print("file saved : \(resizefileURL)")
                    } catch {
                        print("error saving file:", error)
                    }
                }
                self.frame_num  = self.frame_num + 1
            }
        }
    }
    
    private func getBBsFromAPI(image: UIImage, imagew: CGFloat, imageh: CGFloat, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        //TODO: Refactor request API with Combine
        guard let urlString = self.edgeComputingUrl else { return }
        // Asynchronous Http call to your api url, using URLSession:
        let theURL = URL(string: urlString)
        let boundary = UUID().uuidString

        //let session = URLSession(configuration: .default)
        let defaultSession = URLSession(configuration: .default)
        defaultSession.configuration.timeoutIntervalForRequest = 120
        defaultSession.configuration.timeoutIntervalForResource = 120
        var dataTask: URLSessionDataTask?

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: theURL!)
        urlRequest.httpMethod = inferenceType == .clound ? "POST" : "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        if inferenceType == .clound {
            if let token = KeyChainManager.shared.getTokenOutDevice() {
                urlRequest.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            }

        }
        
        var data = Data()

        // Add the image data to the raw http request data
        //data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        let fieldName = inferenceType == .clound ? "image" : "file"
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"testImage.png\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        
        data.append(image.pngData()!)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        urlRequest.httpBody = data
        
        dataTask = defaultSession.dataTask(with: urlRequest, completionHandler: { [weak self] data, response, error in
            completionHandler(data, response, error)
        })
        dataTask?.resume()
    }
    
    private func showBoundingBoxes(predictions: [Prediction]) {
        //print("Show method called ! ")
        for i in 0..<boundingBoxes.count {
            if i < predictions.count {
                let prediction = predictions[i]
                
                // The predicted bounding box is in the coordinate space of the input
                // image, which is a square image of 416x416 pixels. We want to show it
                // on the video preview, which is as wide as the screen and has a 16:9
                // aspect ratio. The video preview also may be letterboxed at the top
                // and bottom.
                
                var width : CGFloat = 0
                var height : CGFloat = 0
                
                let videoRatio : CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 4 / 3 : 16 / 9
                
                let orientation = UIDevice.current.orientation
                let isPortrait = orientation == .portrait || orientation == .portraitUpsideDown
                if (isPortrait) {
                    width = videoPreview.bounds.width
                    height = width * videoRatio
                } else {
                    height = videoPreview.frame.height
                    width = height * videoRatio
                }
                
                let scaleX = width / CGFloat(yolo.inputWidth)
                let scaleY = height / CGFloat(yolo.inputHeight)
                
                //print("WH show method : \(width) , \(height), \(top)")
                
                // Translate and scale the rectangle to our own coordinate system.
                var rect = prediction.rect
                rect.origin.x *= scaleX
                rect.origin.y *= scaleY
                if isPortrait {
                    rect.origin.y += (videoPreview.bounds.height - height) / 2
                } else {
                    rect.origin.x += (videoPreview.bounds.width - width) / 2
                }
                rect.size.width *= scaleX
                rect.size.height *= scaleY
                
                
                // Show the bounding box.
                var label: String = ""
                if prediction.name == "" {
                    label = String(format: "%@ %.2f", yolo.labels.count > prediction.classIndex ? yolo.labels[prediction.classIndex] : "Object_\(prediction.classIndex)", prediction.score)
                } else {
                    label = String(format: "%@ %.2f", prediction.name!, prediction.score)
                }
                
                let color = colors[prediction.classIndex]
                // print("Printing Calculated Rectangle : \(rect)")
                boundingBoxes[i].show(frame: rect, label: label, color: color)
            } else {
                boundingBoxes[i].hide()
            }
        }
    }
}

extension CameraViewController {
    
}
