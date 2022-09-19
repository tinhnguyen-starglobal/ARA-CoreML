//
//  APIBase.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 19/09/2022.
//

import Alamofire
import Combine
import UIKit
import Foundation


public typealias JSONDictionary = [String: Any]
public typealias JSONArray = [JSONDictionary]

public protocol JSONData {
    init()
    static func equal(left: JSONData, right: JSONData) -> Bool
}

extension JSONDictionary: JSONData {
    public static func equal(left: JSONData, right: JSONData) -> Bool {
        // swiftlint:disable:next force_cast
        NSDictionary(dictionary: left as! JSONDictionary).isEqual(to: right as! JSONDictionary)
    }
}

extension JSONArray: JSONData {
    public static func equal(left: JSONData, right: JSONData) -> Bool {
        let leftArray = left as! JSONArray  // swiftlint:disable:this force_cast
        let rightArray = right as! JSONArray  // swiftlint:disable:this force_cast
        
        guard leftArray.count == rightArray.count else { return false }
        
        for i in 0..<leftArray.count {
            if !JSONDictionary.equal(left: leftArray[i], right: rightArray[i]) {
                return false
            }
        }
        
        return true
    }
}

open class APIBase {
    
    public var manager: Alamofire.Session
    
    public convenience init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120
        configuration.timeoutIntervalForResource = 120
        
        self.init(configuration: configuration)
    }
    
    public init(configuration: URLSessionConfiguration) {
        manager = Alamofire.Session(configuration: configuration)
    }
    
    func request<T: Decodable>(_ input: APIBaseInput) -> AnyPublisher<APIResponse<T>, Error> {
        let response: AnyPublisher<APIResponse<JSONDictionary>, Error> = requestJSON(input)
        
        return response
            .tryMap { apiResponse -> APIResponse<T> in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: apiResponse.data,
                                                              options: .prettyPrinted)
                    let t = try JSONDecoder().decode(T.self, from: jsonData)
                    return APIResponse(header: apiResponse.header, data: t)
                } catch {
                    throw APIInvalidResponseError()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func request<T: Decodable>(_ input: APIBaseInput) -> AnyPublisher<T, Error> {
        request(input)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    func request<T: Codable>(_ input: APIBaseInput) -> AnyPublisher<APIResponse<[T]>, Error> {
        let response: AnyPublisher<APIResponse<JSONArray>, Error> = requestJSON(input)
        
        return response
            .tryMap { apiResponse -> APIResponse<[T]> in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: apiResponse.data,
                                                              options: .prettyPrinted)
                    
                    let items = try JSONDecoder().decode([T].self, from: jsonData)
                    return APIResponse(header: apiResponse.header,
                                       data: items)
                } catch {
                    throw APIInvalidResponseError()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func request<T: Decodable>(_ input: APIBaseInput) -> AnyPublisher<[T], Error> {
        request(input)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    func requestJSON<U: JSONData>(_ input: APIBaseInput) -> AnyPublisher<APIResponse<U>, Error> {
        
        let urlRequest = preprocess(input)
            .map { [unowned self] input -> DataRequest in
                let request: DataRequest
                
                if let uploadInput = input as? APIUploadInputBase {
                    request = self.manager.upload(
                        multipartFormData: { (multipartFormData) in
                            input.parameters?.forEach { key, value in
                                if let data = String(describing: value).data(using: .utf8) {
                                    multipartFormData.append(data, withName: key)
                                }
                            }
                            uploadInput.data.forEach({
                                multipartFormData.append(
                                    $0.data,
                                    withName: $0.name,
                                    fileName: $0.fileName,
                                    mimeType: $0.mimeType)
                            })
                        },
                        to: uploadInput.urlString,
                        method: uploadInput.method,
                        headers: uploadInput.headers
                    )
                } else {
                    request = self.manager.request(
                        input.urlString,
                        method: input.method,
                        parameters: input.parameters,
                        encoding: input.encoding,
                        headers: input.headers
                    )
                }
                
                return request
            }
            .handleEvents(receiveOutput: { (dataRequest) in
                debugPrint(dataRequest)
            })
            .flatMap { dataRequest -> AnyPublisher<DataResponse<Data, AFError>, Error> in
                return dataRequest.publishData()
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .tryMap { (dataResponse) -> APIResponse<U> in
                return try self.process(dataResponse)
            }
            .tryCatch { [unowned self] error -> AnyPublisher<APIResponse<U>, Error> in
                return try self.handleRequestError(error, input: input)
            }
            .handleEvents(receiveOutput: { response in
                print(response)
            })
            .eraseToAnyPublisher()
        
        return urlRequest
    }
    
    func preprocess(_ input: APIBaseInput) -> AnyPublisher<APIBaseInput, Error> {
        Just(input)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func process<U: JSONData>(_ dataResponse: DataResponse<Data, AFError>) throws -> APIResponse<U> {
        let error: Error
        
        switch dataResponse.result {
        case .success(let data):
            let json: U? = (try? JSONSerialization.jsonObject(with: data, options: [])) as? U
            
            guard let statusCode = dataResponse.response?.statusCode else {
                throw APIUnknownError(statusCode: nil)
            }
            
            switch statusCode {
            case 200..<300:
                print("👍 [\(statusCode)] " + (dataResponse.response?.url?.absoluteString ?? ""))
                print(dataResponse)
                print("[RESPONSE DATA]")
                print(json ?? data)
                
                // swiftlint:disable:next explicit_init
                return APIResponse(header: dataResponse.response?.allHeaderFields, data: json ?? U.init())
            default:
                error = handleResponseError(dataResponse: dataResponse, json: json)
            }
            
        case .failure(let afError):
            error = afError
        }
        
        throw error
    }
    
    func handleRequestError<U: JSONData>(_ error: Error,
                                         input: APIBaseInput) throws -> AnyPublisher<APIResponse<U>, Error> {
        throw error
    }
    
    func handleResponseError<U: JSONData>(dataResponse: DataResponse<Data, AFError>, json: U?) -> Error {
        if let jsonDictionary = json as? JSONDictionary {
            return handleResponseError(dataResponse: dataResponse, json: jsonDictionary)
        } else if let jsonArray = json as? JSONArray {
            return handleResponseError(dataResponse: dataResponse, json: jsonArray)
        }
        
        return handleResponseUnknownError(dataResponse: dataResponse)
    }
    
    func handleResponseError(dataResponse: DataResponse<Data, AFError>, json: JSONDictionary?) -> Error {
        APIUnknownError(statusCode: dataResponse.response?.statusCode)
    }
    
    func handleResponseError(dataResponse: DataResponse<Data, AFError>, json: JSONArray?) -> Error {
        APIUnknownError(statusCode: dataResponse.response?.statusCode)
    }
    
    func handleResponseUnknownError(dataResponse: DataResponse<Data, AFError>) -> Error {
        APIUnknownError(statusCode: dataResponse.response?.statusCode)
    }
}

