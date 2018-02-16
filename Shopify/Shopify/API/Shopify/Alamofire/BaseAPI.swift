//
//  BaseAPI.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 2/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire
import ShopClient_Gateway

typealias ApiJson = [String: AnyObject]

private let kBaseApiMessageKey = "message"

class BaseAPI {
    private lazy var sessionManager: SessionManager = {
        return SessionManager(configuration: URLSessionConfiguration.default)
    }()
    
    func execute(_ request: URLRequestConvertible, callback: @escaping RepoCallback<ApiJson>) {
        let dataRequest = sessionManager.request(request)
        response(with: dataRequest, callback: callback)
    }
    
    private func response(with request: DataRequest, callback: @escaping RepoCallback<ApiJson>) {
        request.responseJSON { response in
            do {
                let statusCode = response.response?.statusCode ?? 500
                guard statusCode != 201 && statusCode != 204 else {
                    callback(nil, ContentError())
                    return
                }
                guard response.data != nil else {
                    throw ContentError()
                }
                guard let json = response.result.value as? [String: AnyObject] else {
                    throw ContentError()
                }
                guard response.result.error == nil, 200..<300 ~= statusCode else {
                    if let message = json[kBaseApiMessageKey] as? String {
                        throw ContentError(with: message)
                    } else {
                        throw ContentError()
                    }
                }
                callback(json, nil)
            } catch {
                callback(nil, NetworkError())
            }
        }
    }
}
