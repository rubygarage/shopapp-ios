//
//  MagentoStoreRouter.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 5/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire

enum MagentoStoreRoute: Equatable {
    case getConfigs
    
    // MARK: - Equatable
    
    static func == (lhs: MagentoStoreRoute, rhs: MagentoStoreRoute) -> Bool {
        switch (lhs, rhs) {
        case (.getConfigs, .getConfigs):
            return true
        }
    }
}

class MagentoStoreRouter: BaseRouter {
    private let route: MagentoStoreRoute
    
    private var method: HTTPMethod {
        switch route {
        case .getConfigs:
            return .get
        }
    }
    private var path: String {
        switch route {
        case .getConfigs:
            return "store/storeConfigs"
        }
    }
    private var parameters: Parameters? {
        switch route {
        case .getConfigs:
            return nil
        }
    }
    private var headers: [String: String]? {
        switch route {
        case .getConfigs:
            return [contentTypeKey: contentTypeJsonValue]
        }
    }
    
    init(route: MagentoStoreRoute) {
        self.route = route
        
        super.init()
    }
    
    override func buildRequest(with url: URL) throws -> URLRequest {
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        urlRequest.allHTTPHeaderFields = headers
        
        if route == .getConfigs {
            urlRequest.addValue(longCacheMaxAge, forHTTPHeaderField: BaseRouter.cacheControlMaxAgeKey)
        }

        return urlRequest
    }
}
