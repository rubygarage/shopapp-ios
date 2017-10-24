//
//  DAO.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

protocol Repository {
    // MARK: - shop
    func loadShopInfo(with item: ShopEntityInterface?, callback: @escaping ((_ shop: ShopEntity?, _ error: Error?) -> ()))
    func getShop() -> ShopEntity?
    
    // MARK: - categories
    func loadCategories(with items: [CategoryEntityInterface], callback: @escaping ((_ categories: [CategoryEntity]?, _ error: Error?) -> ()))
    func loadCategory(with item: CategoryEntityInterface, callback: @escaping ((_ category: CategoryEntity?, _ error: Error?) -> ()))
    func getCategories() -> [CategoryEntity]?
    func getCategory(with id: String) -> CategoryEntity?
    
    // MARK: - products
    func loadProducts(with items: [ProductEntityInterface], callback: @escaping ((_ products: [ProductEntity]?, _ error: Error?) -> ()))
    func loadProduct(with item: ProductEntityInterface, callback: @escaping ((_ product: ProductEntity?, _ error: Error?) -> ()))
}
