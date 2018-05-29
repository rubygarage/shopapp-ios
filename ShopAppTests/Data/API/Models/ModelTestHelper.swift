//
//  ModelTestHelper.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/15/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

@testable import ShopApp

struct ModelTestHelper {
    struct SimpleModelTest: RequestBody, Response {
        var date: Date
    }
    
    struct ComplexModelTest: RequestBody, Response {
        var string: String
        var array: [String]
        var simpleRequestBody: SimpleModelTest
        
        enum CodingKeys: String, CodingKey {
            case string
            case array
            case simpleRequestBody = "simple_request_body"
        }
    }
    
    private static var dateString: String {
        return "1994-09-27 10:15:00"
    }
    
    static var date: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.date(from: dateString) ?? Date()
    }
    static var simpleParameters: [String: Any] {
        return ["date": dateString]
    }
    static var complexParameters: [String: Any] {
        return ["string": "string",
                "array": ["array"],
                "simple_request_body": simpleParameters]
    }
}
