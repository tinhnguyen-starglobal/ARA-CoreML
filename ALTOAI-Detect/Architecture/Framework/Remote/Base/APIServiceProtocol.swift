//
//  APIServiceProtocol.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 19/09/2022.
//

import Combine

protocol APIServiceProtocol {
    func request<T: Codable>(_ input: APIBaseInput, atKeyPath keyPath: String?) -> AnyPublisher<T, Error>
}
