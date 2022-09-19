//
//  APIResponse.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 19/09/2022.
//

import Foundation

public typealias ResponseHeader = [AnyHashable: Any]

struct APIResponse<T> {
    
    var header: ResponseHeader?
    var data: T
    
    init(header: ResponseHeader?, data: T) {
        self.header = header
        self.data = data
    }
}
