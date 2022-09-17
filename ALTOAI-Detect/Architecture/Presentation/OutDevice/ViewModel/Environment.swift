//
//  Environment.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 15/09/2022.
//

import Foundation

enum EnvironmentType {
    case qaServer
    case proServer
    
    var title: String {
        switch self {
        case .qaServer:
            return "QA servers"
        case .proServer:
            return "Production servers"
        }
    }
}

struct Environment {
    var title: String
    var selected = false
}
