//
//  BaseRouter.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire
import ShopApp_Gateway

class BaseRouter: URLRequestConvertible {
    static var hostUrl: String?
    static var baseUrl: String?
    
    let contentTypeKey = "Content-Type"
    let contentTypeJsonValue = "application/json"
    let authorizationKey = "Authorization"
    let authorizationBearerValue = "Bearer %@"
    
    func buildRequest(with url: URL) throws -> URLRequest {
        return URLRequest(url: url)
    }
    
    // MARK: - URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        guard let hostUrl = BaseRouter.hostUrl, let baseUrl = BaseRouter.baseUrl, let url = URL(string: hostUrl + baseUrl) else {
            throw ContentError()
        }
        
        return try buildRequest(with: url)
    }
}
