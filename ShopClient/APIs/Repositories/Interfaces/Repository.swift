//
//  DAO.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

protocol Repository {
    // MARK: - shop
    func loadShopInfo(with item: ShopEntityInterface?, callback: @escaping ((_ shop: Shop?, _ error: Error?) -> ()))
    func getShop() -> Shop?
    
    // MARK: - categories
    func loadCategories(with items: [CategoryEntityInterface], callback: @escaping ((_ categories: [Category]?, _ error: Error?) -> ()))
    func loadCategory(with item: CategoryEntityInterface, callback: @escaping ((_ category: Category?, _ error: Error?) -> ()))
    func getCategories() -> [Category]?
    func getCategory(with id: String) -> Category?
    
    // MARK: - products
    func loadProducts(with items: [ProductEntityInterface], callback: @escaping ((_ products: [Product]?, _ error: Error?) -> ()))
    func loadProduct(with item: ProductEntityInterface, callback: @escaping ((_ product: Product?, _ error: Error?) -> ()))
}
