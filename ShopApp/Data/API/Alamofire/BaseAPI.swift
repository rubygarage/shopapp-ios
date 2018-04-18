//
//  BaseAPI.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/18/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire
import ShopApp_Gateway

public class BaseAPI {
    private let okStatusCode = 200
    private let multipleChoicesStatusCode = 300
    private let errorMessageKey = "message"
    private let sessionManager = SessionManager(configuration: .default)
    private let reachabilityManager = NetworkReachabilityManager()
    
    func execute(_ request: URLRequestConvertible, callback: @escaping RepoCallback<Any>) {
        if reachabilityManager?.isReachable ?? false == true {
            let dataRequest = sessionManager.request(request)
            response(with: dataRequest, callback: callback)
        } else {
            callback(nil, NetworkError())
        }
    }
    
    private func response(with request: DataRequest, callback: @escaping RepoCallback<Any>) {
        request.responseJSON { [weak self] response in
            guard let strongSelf = self else {
                return
            }
            
            guard response.error == nil, let statusCode = response.response?.statusCode, strongSelf.okStatusCode..<strongSelf.multipleChoicesStatusCode ~= statusCode, let value = response.value else {
                strongSelf.buildError(with: response, callback: callback)
                
                return
            }
            
            callback(value, nil)
        }
    }
    
    private func buildError(with response: DataResponse<Any>, callback: @escaping RepoCallback<Any>) {
        guard let json = response.value as? [String: AnyObject], let message = json[errorMessageKey] as? String else {
            callback(nil, ContentError())
            
            return
        }
        
        // TODO: Build message with parameters from error json
        
        let error = NonCriticalError(with: message)
        error.statusCode = response.response?.statusCode ?? 0
        
        callback(nil, error)
    }
}
