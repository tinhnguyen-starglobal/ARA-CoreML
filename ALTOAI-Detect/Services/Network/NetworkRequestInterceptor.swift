//
//  NetworkManager+RequestInterceptor.swift
//  ALTOAI-Detect
//
//  Created by Volodymyr Grek on 27.07.2021.
//

import Alamofire


class NetworkRequestInterceptor: RequestInterceptor {
    let retryLimit = 5
    let retryDelay : TimeInterval = 3
    var isRefreshing: Bool = false
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Swift.Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        if let token = KeyChainManager.shared.getToken() {
            request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        
        guard request.retryCount < retryLimit else {
            completion(.doNotRetry)
            return
        }
        
        switch statusCode {
        case 200...299:
            completion(.doNotRetry)
        case 401:
            completion(.doNotRetry)
//            self.reAuthorize { isSuccess in
//                isSuccess ? completion(.retry) : completion(.doNotRetry)
//            }
//            break
        default:
            completion(.retry)
        }
        
    }
    
    private func reAuthorize(completion: @escaping (_ isSuccess: Bool) -> Void) {
        let credentials =  KeyChainManager.shared.getUserCredentials()
        if let apiKey = credentials.apiKey, let apiSecret = credentials.secretKey {
            APIManager.shared().authorize(apiKey: apiKey, apiSecret: apiSecret) { (isSuccess, error) in
                if isSuccess {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
}
