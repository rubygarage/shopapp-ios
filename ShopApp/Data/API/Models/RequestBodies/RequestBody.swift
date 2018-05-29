//
//  RequestBody.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire

protocol RequestBody: Encodable {
    var parameters: Parameters? { get }
}

extension RequestBody {
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter
    }
    private var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(formatter)
        
        return encoder
    }
    
    var parameters: Parameters? {
        guard let data = try? encoder.encode(self), let jsonObject = try? JSONSerialization.jsonObject(with: data), let parameters = jsonObject as? Parameters else {
            return nil
        }
        
        return parameters
    }
}
