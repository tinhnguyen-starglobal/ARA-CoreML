//
//  NetworkManager.swift
//  ALTOAI-Detect
//
//  Created by Volodymyr Grek on 27.07.2021.
//

import Alamofire
import Foundation

enum APIType {
    case outDevice
    case onDevice
}

class APIManager {
    
    static let sharedManager: APIManager = {
        return APIManager()
    }()
    
    var typeAPI: APIType = .onDevice
    
    class func shared(_ type: APIType = .onDevice) -> APIManager {
        sharedManager.typeAPI = type
        return sharedManager
    }
    
    typealias completionHandler = ((Result<Data, CustomError>) -> Void)
    
    var sessionManager: Session = {
        let networkLogger = NetworkLogger()
        var interceptor = NetworkRequestInterceptor()
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = true
        return Session(configuration: configuration, interceptor: interceptor, eventMonitors: [networkLogger])
    }()

    func authorize(apiKey: String, apiSecret: String, completion: @escaping (Bool, Error?) -> Void) {
        (sessionManager.interceptor as? NetworkRequestInterceptor)?.apiType = typeAPI
        let url = typeAPI == .outDevice ? Constants.DemoServer.baseURL : Constants.ProductionServer.baseURL
        sessionManager.request(APIRouter.login(apiKey: apiKey, apiSecret: apiSecret, url: url)).responseDecodable(of: AccessToken.self) { [weak self] response in
            guard let self = self else { return }
            if response.response?.statusCode == 400 {
                completion(false, CustomError.incorrectCredentials)
            } else {
                guard let token = response.value else {
                    return completion(false, response.error)
                }
                
                switch self.typeAPI {
                    case .outDevice:
                        KeyChainManager.shared.signInOutDevice(apiKey: apiKey, secretKey: apiSecret, token: token.accessToken)
                    case .onDevice:
                        KeyChainManager.shared.signInOnDevice(apiKey: apiKey, secretKey: apiSecret, token: token.accessToken)
                }
                
                completion(true, nil)
            }
        }
    }
    
    func getProjects(completion: @escaping ([Project]?, Error?) -> Void) {
        (sessionManager.interceptor as? NetworkRequestInterceptor)?.apiType = typeAPI
        let url = typeAPI == .outDevice ? Constants.DemoServer.baseURL : Constants.ProductionServer.baseURL
        sessionManager.request(APIRouter.getProjects(url: url)).responseDecodable(of: [Project].self) { response in
            guard let objects = response.value else {
                completion(nil, CustomError.cantGetProjects)
                return
            }
            completion(objects, nil)
        }
    }
    
    func getScenes(projectId : String, completion: @escaping ([Scene]?, Error?) -> Void) {
        (sessionManager.interceptor as? NetworkRequestInterceptor)?.apiType = typeAPI
        let url = typeAPI == .outDevice ? Constants.DemoServer.baseURL : Constants.ProductionServer.baseURL
        sessionManager.request(APIRouter.getScenes(projectId: projectId, url: url)).responseDecodable(of: [Scene].self) { response in
            guard let objects = response.value else {
                completion(nil, CustomError.cantGetScenes)
                return
            }
            completion(objects, nil)
        }
    }
    
    func getExperiments(sceneId : String, completion: @escaping ([Experiment]?, Error?) -> Void) {
        (sessionManager.interceptor as? NetworkRequestInterceptor)?.apiType = typeAPI
        let url = typeAPI == .outDevice ? Constants.DemoServer.baseURL : Constants.ProductionServer.baseURL
        sessionManager.request(APIRouter.getExperiments(sceneId: sceneId, url: url)).responseDecodable(of: [Experiment].self) { response in
            guard let objects = response.value else {
                completion(nil, CustomError.cantGetExperiments)
                return
            }
            completion(objects, nil)
        }
    }
    
    func getExperimentRuns(experimentId : String, completion: @escaping ([ExperimentRun]?, Error?) -> Void) {
        (sessionManager.interceptor as? NetworkRequestInterceptor)?.apiType = typeAPI
        let url = typeAPI == .outDevice ? Constants.DemoServer.baseURL : Constants.ProductionServer.baseURL
        sessionManager.request(APIRouter.getExperimentRun(experimentId: experimentId, url: url)).responseDecodable(of: [ExperimentRun].self) { response in
            guard let objects = response.value else {
                completion(nil, CustomError.cantGetExperimentRuns)
                return
            }
            completion(objects, nil)
        }
    }
    
    func downloadModel(experimentId : String, runId: String, completion: @escaping (URL?) -> Void) {
        (sessionManager.interceptor as? NetworkRequestInterceptor)?.apiType = typeAPI
        let url = typeAPI == .outDevice ? Constants.DemoServer.baseURL : Constants.ProductionServer.baseURL
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("\(experimentId)-\(runId).zip")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        sessionManager.download(APIRouter.getModel(experimentId: experimentId, runId: runId, url: url) , to:destination).response { response in
            if response.error == nil, let zipURL = response.fileURL {
                print(zipURL)
                completion(zipURL)
            } else {
                completion(nil)
            }
        }
    }
}

