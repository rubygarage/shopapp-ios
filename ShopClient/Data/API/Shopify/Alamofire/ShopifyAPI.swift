//
//  ShopifyAPI.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 2/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation
import Alamofire

private let kShopifyAdminApiKey = "d64eae31336ae451296daf24f52b0327"
private let kShopifyAdminPassword = "b54086c46fe6825198e4542a96499d51"
private let kShopifyAdminCountriesKey = "countries"
private let kShopifyAdminCountriesRestOfWorldValue = "Rest of World"
private let kShopifyCountriesFileName = "Countries"
private let kShopifyCountriesFileType = "json"

enum ShopifyRouter: URLRequestConvertible {
    case getCountries
    
    private var baseURLString: String {
        return kHttpsUrlPrefix + kShopifyStorefrontURL
    }
    private var headers: [String: String]? {
        let utf8 = ("\(kShopifyAdminApiKey):\(kShopifyAdminPassword)").utf8
        let base64 = Data(utf8).base64EncodedString()
        return ["Authorization": "Basic \(base64)"]
    }
    private var path: String {
        switch self {
        case .getCountries:
            return "/admin/countries.json"
        }
    }
    private var method: HTTPMethod {
        switch self {
        case .getCountries:
            return .get
        }
    }
    private var parameters: [String: Any] {
        var parameters: [String: Any]!
        switch self {
        case .getCountries:
            parameters = [:]
        }
        return parameters
    }
    
    func asURLRequest() throws -> URLRequest {
        var url = try baseURLString.asURL()
        url = url.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        switch self {
        case .getCountries:
            request = try URLEncoding.default.encode(request, with: parameters)
        }
        return request
    }
}

class ShopifyAPI: BaseAPI {
    func getCountries(callback: @escaping RepoCallback<[Country]>) {
        let request = ShopifyRouter.getCountries
        execute(request) { (response, error) in
            if let error = error {
                callback(nil, error)
            } else if let response = response, let items = response[kShopifyAdminCountriesKey] as? [ApiJson] {
                var countries = self.countries(with: items)
                guard countries.filter({ $0.name == kShopifyAdminCountriesRestOfWorldValue }).first != nil else {
                    callback(countries, nil)
                    return
                }
                guard let path = Bundle.main.path(forResource: kShopifyCountriesFileName, ofType: kShopifyCountriesFileType) else {
                    callback(nil, ContentError())
                    return
                }
                do {
                    let url = URL(fileURLWithPath: path)
                    let data = try Data(contentsOf: url, options: .mappedIfSafe)
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    guard let items = json as? [ApiJson] else {
                        callback(nil, ContentError())
                        return
                    }
                    countries = self.countries(with: items)
                    callback(countries, nil)
                } catch {
                    callback(nil, ContentError())
                }
            } else {
                callback(nil, ContentError())
            }
        }
    }
    
    private func countries(with items: [ApiJson]) -> [Country] {
        var countries: [Country] = []
        items.forEach {
            if let country = Country(with: $0) {
                countries.append(country)
            }
        }
        return countries
    }
}
