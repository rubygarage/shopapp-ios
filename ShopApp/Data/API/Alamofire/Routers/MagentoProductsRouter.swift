//
//  MagentoProductsRouter.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/27/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire

enum MagentoProductsRoute {
    case getProducts(parameters: Parameters)
    case getProduct(sku: String)
}

class MagentoProductsRouter: BaseRouter {
    private let route: MagentoProductsRoute
    
    private var method: HTTPMethod {
        switch route {
        case .getProducts, .getProduct:
            return .get
        }
    }
    private var path: String {
        switch route {
        case .getProducts:
            return "products"
        case .getProduct(let sku):
            return "products/" + sku
        }
    }
    private var parameters: Parameters? {
        switch route {
        case .getProducts(let patameters):
            return patameters
        case .getProduct:
            return nil
        }
    }
    private var headers: [String: String]? {
        switch route {
        case .getProducts, .getProduct:
            return [contentTypeKey: contentTypeJsonValue]
        }
    }
    
    init(route: MagentoProductsRoute) {
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
