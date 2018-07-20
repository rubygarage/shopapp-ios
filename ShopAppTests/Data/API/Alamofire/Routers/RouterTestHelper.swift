//
//  RouterTestHelper.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/18/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire

@testable import ShopApp

struct RouterTestHelper {
    static var hostUrl: String {
        return "http://host/"
    }
    static var baseUrl: String {
        return "rest/"
    }
    static var url: URL {
        return URL(string: hostUrl + baseUrl)!
    }
    static var parameters: [String: String]  {
        return ["key": "value"]
    }
    static var parametersAsUrlParams: String {
        return "?" + parameters.map({ "\($0)=\($1)" }).joined(separator: "&")
    }
}

struct RequestBodyTest: Request {
    var key: String
}
