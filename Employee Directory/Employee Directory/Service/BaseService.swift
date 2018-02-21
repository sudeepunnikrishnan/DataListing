//
//  BaseService.swift
//  Employee Directory
//
//  Created by Sudeep.Unnikrishnan on 23/12/17.
//  Copyright © 2017 Sudeep Unnikrishnan. All rights reserved.
//

import Foundation

enum ServiceError: Error, CustomStringConvertible {
    case unknown
    case invalidResponse
    
    var description: String {
        switch self {
        case .unknown: return "An unknown error occurred"
        case .invalidResponse: return "Received an invalid response"
        }
    }
}

protocol Service {
    func makeRequest(request: BaseServiceRequest, success: @escaping ([String : AnyObject]) -> Void, failure: @escaping (Error) -> Void)
}


class BaseService: Service {
    
    //MARK: - Private
    let session: URLSession
    let sessionDelegate = SessionDelegate()
    //MARK: - Lifecycle
    init() {
        session = URLSession.init(configuration: .default, delegate: sessionDelegate, delegateQueue: nil)
    }
    
    //MARK: - Public
    func makeRequest(request: BaseServiceRequest, success: @escaping ([String : AnyObject]) -> Void, failure: @escaping (Error) -> Void)  {
        do {
            let request = try request.buildURLRequest()
            let task = session.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    DispatchQueue.main.async() { failure(error ?? ServiceError.unknown) }
                    return
                }
                
                guard
                    let jsonOptional = try? JSONSerialization.jsonObject(with: data, options: []),
                    let json = jsonOptional as? [String: AnyObject]
                    else {
                        DispatchQueue.main.async() { failure(ServiceError.invalidResponse) }
                        return
                }
                DispatchQueue.main.async() { success(json) }
            }
            task.resume()
        } catch let error {
            failure(error)
        }
    }
}

class SessionDelegate:NSObject, URLSessionDelegate
{
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
        {
            print(challenge.protectionSpace.host)
            if checkForHost(challenge.protectionSpace.host)
            {
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
            }
        }
        
    }
    
    func checkForHost(_ host : String) -> Bool{
        switch host {
        case "tartu.jobapp.aw.ee":
            return true
        default:
            return false
        }
    }
}
