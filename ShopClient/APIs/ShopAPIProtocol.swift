//
//  ShopAPIProtocol.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 8/30/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

typealias ApiCallback<T> = (_ result: T?, _ error: Error?) -> ()

protocol ShopAPIProtocol {    
    // MARK: - products
    func getProductList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping ApiCallback<[ProductEntity]>)
    func getProduct(id: String, options: [SelectedOption], callback: @escaping ApiCallback<ProductEntity>)
    func searchProducts(perPage: Int, paginationValue: Any?, searchQuery: String, callback: @escaping ApiCallback<[ProductEntity]>)
    
    // MARK: - categories
    func getCategoryList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping ApiCallback<[CategoryEntity]>)
    func getCategoryDetails(id: String, perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping ApiCallback<CategoryEntity>)
    
    // MARK: - articles
    func getArticleList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping ApiCallback<[Article]>)
}
