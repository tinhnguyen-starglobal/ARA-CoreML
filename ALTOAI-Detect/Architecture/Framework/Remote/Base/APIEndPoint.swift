//
//  APIEndPoint.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 19/09/2022.
//

import Foundation

protocol APIEndPoint {
    var host: String { get set}
    var version: String { get }
    var path: String { get }
}

extension APIEndPoint {
    var host: String {
        return ""
    }

    var version: String {
        return ""
    }

    var endpoint: String {
        return host + version + path
    }
}

