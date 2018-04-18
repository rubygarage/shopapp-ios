//
//  Response.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

protocol Response: Decodable {
    static func object(from json: [String: Any]) -> Self?
    static func objects(from json: [Any]) -> [Self]?
}

extension Response {
    private static var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter
    }
    private static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return decoder
    }
    
    static func object(from json: [String: Any]) -> Self? {
        guard let data = try? JSONSerialization.data(withJSONObject: json), let object = try? decoder.decode(self, from: data) else {
            return nil
        }

        return object
    }
    
    static func objects(from json: [Any]) -> [Self]? {
        guard let data = try? JSONSerialization.data(withJSONObject: json), let objects = try? decoder.decode([Self].self, from: data) else {
            return nil
        }
        
        return objects
    }
}
