//
//  MagentoCartRouter.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 6/8/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire

enum MagentoCartRoute {
    case createQuoteAuthorized(token: String)
    case createQuoteUnauthorized
    case getCartProductsAuthorized(token: String)
    case getCartProductsUnauthorized(quoteId: String)
    case addCartProductAuthorized(token: String, body: RequestBody)
    case addCartProductUnauthorized(quoteId: String, body: RequestBody)
    case changeCartProductQuantityAuthorized(token: String, itemId: String, body: RequestBody)
    case changeCartProductQuantityUnauthorized(quoteId: String, itemId: String, body: RequestBody)
    case deleteCartProductAuthorized(token: String, quoteId: String, itemId: String)
    case deleteCartProductUnauthorized(quoteId: String, itemId: String)
}

class MagentoCartRouter: BaseRouter {
    private let route: MagentoCartRoute
    
    private var method: HTTPMethod {
        switch route {
        case .getCartProductsAuthorized, .getCartProductsUnauthorized:
            return .get
        case .createQuoteAuthorized, .createQuoteUnauthorized, .addCartProductAuthorized, .addCartProductUnauthorized:
            return .post
        case .changeCartProductQuantityAuthorized, .changeCartProductQuantityUnauthorized:
            return .put
        case .deleteCartProductAuthorized, .deleteCartProductUnauthorized:
            return .delete
        }
    }
    private var path: String {
        switch route {
        case .createQuoteAuthorized:
            return "carts/mine"
        case .createQuoteUnauthorized:
            return "guest-carts"
        case .getCartProductsAuthorized:
            return "carts/mine/items"
        case .getCartProductsUnauthorized(let quoteId):
            return "guest-carts/\(quoteId)/items"
        case .addCartProductAuthorized:
            return "carts/mine/items"
        case .addCartProductUnauthorized(let quoteId, _):
            return "guest-carts/\(quoteId)/items"
        case .changeCartProductQuantityAuthorized(_, let itemId, _):
            return "carts/mine/items/\(itemId)"
        case .changeCartProductQuantityUnauthorized(let quoteId, let itemId, _):
            return "guest-carts/\(quoteId)/items/\(itemId)"
        case .deleteCartProductAuthorized(_, _, let itemId):
            return "carts/mine/items/\(itemId)"
        case .deleteCartProductUnauthorized(let quoteId, let itemId):
            return "guest-carts/\(quoteId)/items/\(itemId)"
        }
    }
    private var parameters: Parameters? {
        switch route {
        case .addCartProductAuthorized(_, let body):
            return ["cartItem": body.parameters as Any]
        case .addCartProductUnauthorized(_, let body):
            return ["cartItem": body.parameters as Any]
        case .changeCartProductQuantityAuthorized(_, _, let body):
            return ["cartItem": body.parameters as Any]
        case .changeCartProductQuantityUnauthorized(_, _, let body):
            return ["cartItem": body.parameters as Any]
        default:
            return nil
        }
    }
    private var headers: [String: String]? {
        var bearerToken: String?
        
        switch route {
        case .createQuoteAuthorized(let token), .getCartProductsAuthorized(let token), .addCartProductAuthorized(let token, _), .changeCartProductQuantityAuthorized(let token, _, _), .deleteCartProductAuthorized(let token, _, _):
            bearerToken = token
        default:
            break
        }
        
        guard let token = bearerToken else {
            return nil
        }
        
        return [authorizationKey: String(format: authorizationBearerValue, arguments: [token])]
    }
    
    init(route: MagentoCartRoute) {
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
