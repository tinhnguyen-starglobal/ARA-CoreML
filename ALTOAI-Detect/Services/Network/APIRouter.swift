//
//  APIRouter.swift
//  ALTOAI-Detect
//
//  Created by Volodymyr Grek on 20.07.2021.
//

import Foundation
import Alamofire
import SimpleKeychain

enum APIRouter: APIConfiguration {

    case login(apiKey: String, apiSecret: String, url: String)
    case getProjects(url: String)
    case getScenes(projectId: String, url: String)
    case getExperiments(sceneId: String, url: String)
    case getExperimentRun(experimentId: String, url: String)
    case getModel(experimentId: String, runId: String)
    
    var url: String {
        switch self {
        case .login(_, _, let url):
            return url
        case .getProjects(let url):
            return url
        case .getScenes(_, let url):
            return url
        case .getExperiments(_, let url):
            return url
        case .getExperimentRun(_, let url):
            return url
        default:
            return Constants.ProductionServer.baseURL
        }
    }
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .getProjects:
            return .get
        case .getScenes:
            return .get
        case .getExperiments:
            return .get
        case .getExperimentRun:
            return .get
        case .getModel:
            return .get
        }
    }
    // MARK: - Parameters
    var parameters: RequestParams {
        switch self {
        case .login(let apiKey, let apiSecret, _):
            return .body(["client_id": apiKey,"client_secret": apiSecret])
        case .getProjects:
            return.body([:])
        case .getScenes:
            return.body([:])
        case .getExperiments:
            return.body([:])
        case .getExperimentRun:
            return.body([:])
        case .getModel:
            return.url(["type": "ML"])
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .login:
            return "/auth"
        case .getProjects:
            return "/ar/data/projects"
        case .getScenes(let projectId, _):
            return "/ar/data/projects/\(projectId)/scenes"
        case .getExperiments(let sceneId, _):
            return "/ar/data/scenes/\(sceneId)/experiments"
        case .getExperimentRun(let experimentId, _):
            return "/ar/data/experiments/\(experimentId)/run"
        case .getModel(let experimentId, let runId):
            return "/ar/data/experiments/\(experimentId)/run/\(runId)/models"
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try self.url.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        
        switch(self) {
        case .login:
            urlRequest.setValue(ContentType.formEncode.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            break
        default:
            urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        }
        
        // Parameters
        switch parameters {
            
        case .body(let params):
            switch(self) {
            case .login:
                let jsonString = params.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
                if let data = jsonString.data(using: .utf8, allowLossyConversion: false), data.count > 0 {
                    urlRequest.httpBody = data
                }
                break
            default:
                do {
                    if params.count > 0 {
                        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        case .url(let params):
            let queryParams = params.map { pair  in
                return URLQueryItem(name: pair.key, value: "\(pair.value)")
            }
            var components = URLComponents(string:url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
        }
        return urlRequest
    }
}
