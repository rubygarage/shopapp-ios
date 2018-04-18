//
//  MagentoCustomerRouter.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire

enum MagentoCustomerRoute {
    case signUp(body: RequestBody)
    case getToken(body: RequestBody)
    case getCustomer(token: String)
    case updatePassword(token: String, body: RequestBody)
    case resetPassword(body: RequestBody)
    case updateCustomer(token: String, body: RequestBody)
}

class MagentoCustomerRouter: BaseRouter {
    private let route: MagentoCustomerRoute
    
    private var method: HTTPMethod {
        switch route {
        case .signUp, .getToken:
            return .post
        case .getCustomer:
            return .get
        case .updatePassword, .resetPassword, .updateCustomer:
            return .put
        }
    }
    private var path: String {
        switch route {
        case .signUp:
            return "customers"
        case .getToken:
            return "integration/customer/token"
        case .getCustomer, .updateCustomer:
            return "customers/me"
        case .updatePassword:
            return "customers/me/password"
        case .resetPassword:
            return "customers/password"
        }
    }
    private var parameters: Parameters? {
        switch route {
        case .signUp(let body):
            return body.parameters
        case .getToken(let body):
            return body.parameters
        case .getCustomer:
            return nil
        case .updatePassword(_, let body):
            return body.parameters
        case .resetPassword(let body):
            return body.parameters
        case .updateCustomer(_, let body):
            return body.parameters
        }
    }
    private var headers: [String: String]? {
        var bearerToken: String?
        
        switch route {
        case .getCustomer(let token):
            bearerToken = token
        case .updatePassword(let token, _):
            bearerToken = token
        case .updateCustomer(let token, _):
            bearerToken = token
        default:
            break
        }
        
        guard let token = bearerToken else {
            return nil
        }

        return [authorizationKey: String(format: authorizationBearerValue, arguments: [token])]
    }
    
    init(route: MagentoCustomerRoute) {
        self.route = route
        
        super.init()
    }
    
    override func buildRequest(with url: URL) throws -> URLRequest {
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        return try JSONEncoding.default.encode(urlRequest, with: parameters)
    }
}
