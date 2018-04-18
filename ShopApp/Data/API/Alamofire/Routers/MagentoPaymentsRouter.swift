//
//  MagentoPaymentsRouter.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire

enum MagentoPaymentsRoute: Equatable {
    case getCountries
    
    // MARK: - Equatable
    
    static func == (lhs: MagentoPaymentsRoute, rhs: MagentoPaymentsRoute) -> Bool {
        switch (lhs, rhs) {
        case (.getCountries, .getCountries):
            return true
        }
    }
}

class MagentoPaymentsRouter: BaseRouter {
    private let route: MagentoPaymentsRoute
    
    private var method: HTTPMethod {
        switch route {
        case .getCountries:
            return .get
        }
    }
    private var path: String {
        switch route {
        case .getCountries:
            return "directory/countries"
        }
    }
    private var parameters: Parameters? {
        switch route {
        case .getCountries:
            return nil
        }
    }
    
    init(route: MagentoPaymentsRoute) {
        self.route = route
        
        super.init()
    }
    
    override func buildRequest(with url: URL) throws -> URLRequest {
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        if route == .getCountries {
            urlRequest.cachePolicy = .returnCacheDataElseLoad
        }
        
        return try JSONEncoding.default.encode(urlRequest, with: parameters)
    }
}
