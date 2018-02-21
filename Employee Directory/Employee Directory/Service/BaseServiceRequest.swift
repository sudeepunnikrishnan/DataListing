//
//  BaseServiceRequest.swift
//  Employee Directory
//
//  Created by Sudeep.Unnikrishnan on 23/12/17.
//  Copyright © 2017 Sudeep Unnikrishnan. All rights reserved.
//

import Foundation

enum BaseServiceRequestError: Error, CustomStringConvertible {
    case InvalidURL(String)
    
    var description: String {
        switch self {
        case .InvalidURL(let url): return "The url '\(url)' was invalid"
        }
    }
}

struct BaseServiceRequest {
    //MARK: - HTTP Methods
    enum Method: String {
        case get        = "GET"
        case post       = "POST"
    }
    
    //MARK: - Public Properties
    let method: BaseServiceRequest.Method
    let url: String
    
    //MARK: - Public Functions
    func buildURLRequest() throws -> URLRequest {
        guard let url = URL(string: self.url) else { throw BaseServiceRequestError.InvalidURL(self.url) }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
