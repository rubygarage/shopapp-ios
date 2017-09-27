//
//  ShopAPIProtocol.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 8/30/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

typealias ApiCallback<T> = (_ result: T?, _ error: Error?) -> ()

enum SortingValue: Int {
    case createdAt
    case name
    
    static let allValues = [NSLocalizedString("SortingValue.CreatedAt", comment: String()),
                            NSLocalizedString("SortingValue.Name", comment: String())]
}

protocol ShopAPIProtocol {
    // MARK: - shop info
    func getShopInfo(callback: @escaping ApiCallback<Shop>)
    
    // MARK: - products
    func getProductList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping ApiCallback<[Product]>)
    func getProduct(id: String, callback: @escaping ApiCallback<Product>)
    func searchProducts(perPage: Int, paginationValue: Any?, searchQuery: String, callback: @escaping ApiCallback<[Product]>)
    
    // MARK: - categories
    func getCategoryList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping ApiCallback<[Category]>)
    func getCategoryDetails(id: String, perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping ApiCallback<Category>)
    
    // MARK: - articles
    func getArticleList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping ApiCallback<[Article]>)
}
