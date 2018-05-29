//
//  MagentoCategoriesRouter.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 5/10/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire

enum MagentoCategoriesRoute {
    case getCategories(parameters: Parameters)
    case getCategory(id: String)
}

class MagentoCategoriesRouter: BaseRouter {
    private let route: MagentoCategoriesRoute
    
    private var method: HTTPMethod {
        switch route {
        case .getCategories, .getCategory:
            return .get
        }
    }
    private var path: String {
        switch route {
        case .getCategories:
            return "categories"
        case .getCategory(let id):
            return "categories/" + id
        }
    }
    private var parameters: Parameters? {
        switch route {
        case .getCategories(let patameters):
            return patameters
        case .getCategory:
            return nil
        }
    }
    private var headers: [String: String]? {
        switch route {
        case .getCategories, .getCategory:
            return [contentTypeKey: contentTypeJsonValue]
        }
    }
    
    init(route: MagentoCategoriesRoute) {
        self.route = route
        
        super.init()
    }
    
    override func buildRequest(with url: URL) throws -> URLRequest {
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        urlRequest.allHTTPHeaderFields = headers
        
        return urlRequest
    }
}
