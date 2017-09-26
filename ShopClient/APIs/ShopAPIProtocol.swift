//
//  ShopAPIProtocol.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 8/30/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

typealias ApiCallback<T> = (_ result: T?, _ error: Error?) -> ()

enum SortingValue {
    case name
    case createdAt
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
    func getCategoryDetails(id: String, perPage: Int, paginationValue: Any?, callback: @escaping ApiCallback<Category>)
    
    // MARK: - articles
    func getArticleList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping ApiCallback<[Article]>)
}
