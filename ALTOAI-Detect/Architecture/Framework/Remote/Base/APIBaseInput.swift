//
//  APIBaseInput.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 19/09/2022.
//

import Alamofire
import Foundation

class APIBaseInput {
    
    public var urlString: String
    public var method: HTTPMethod
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    public var encoding: ParameterEncoding
    
    public init(urlString: String, parameters: Parameters?, method: HTTPMethod) {
        self.urlString = urlString
        self.parameters = parameters
        self.method = method
        self.encoding = method == .get ? URLEncoding.default : JSONEncoding.default
    }
}

// MARK: - APIBaseInput support encoding url
extension APIBaseInput {
    
    var urlEncodingString: String {
        guard let url = URL(string: urlString),
              var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let parameters = parameters, method == .get else {
                  return urlString
        }
        
        urlComponents.queryItems = []
        
        for name in parameters.keys.sorted() {
            if let value = parameters[name] {
                let item = URLQueryItem(
                    name: "\(name)",
                    value: "\(value)"
                )
                urlComponents.queryItems?.append(item)
            }
        }
        
        return urlComponents.url?.absoluteString ?? urlString
    }
    
    func description(isIncludedParameters: Bool) -> String {
        if method == .get || !isIncludedParameters {
            return "🍎 \(method.rawValue) \(urlEncodingString)"
        }
        
        return [
            "🍎 \(method.rawValue) \(urlString)",
            "Parameters: \(String(describing: parameters ?? [String: Any]()))"
        ].joined(separator: "\n")
    }
}

struct APIUploadData {
    let data: Data
    let name: String
    let fileName: String
    let mimeType: String
    
    init(data: Data, name: String, fileName: String, mimeType: String) {
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }
}

class APIUploadInputBase: APIBaseInput {
    
    let data: [APIUploadData]
    
    init(data: [APIUploadData],
                urlString: String,
                parameters: [String: Encodable]?,
                method: HTTPMethod) {
        
        self.data = data
        
        super.init(
            urlString: urlString,
            parameters: parameters,
            method: method
        )
        
        self.headers = [
            "Content-Type": "multipart/form-data",
            "auth-token": ""
        ]
    }
}

