//
//  RepositoriesManager.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/18/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class RepositoriesManager: NSObject {
    static let shared = RepositoriesManager()
    var categoryRepository: CategoryRepository?
    var productRepository: ProductRepository?
    
    override init() {
        super.init()
        
        setupRepositories()
    }
    
    private func setupRepositories() {
        categoryRepository = MagicalRecordCategoryRepository()
        productRepository = MagicalRecordProductRepository()
    }
    
    // MARK: - categories
    func loadCategories(with items: [CategoryEntityInterface], callback: @escaping ((_ categories: [Category]?, _ error: Error?) -> ())) {
        categoryRepository?.loadCategories(with: items, callback: callback)
    }
    
    func loadCategory(with item: CategoryEntityInterface, callback: @escaping ((_ category: Category?, _ error: Error?) -> ())) {
        categoryRepository?.loadCategory(with: item, callback: callback)
    }

    func getCategories() -> [Category] {
        return categoryRepository?.getCategories() ?? [Category]()
    }
    
    func getCategory(with id: String) -> Category? {
        return categoryRepository?.getCategory(with: id)
    }
    
    // MARK: - products
    func loadProducts(with items: [ProductEntityInterface], callback: @escaping ((_ products: [Product]?, _ error: Error?) -> ())) {
        productRepository?.loadProducts(with: items, callback: callback)
    }
    
    func loadProduct(with item: ProductEntityInterface, callback: @escaping ((_ product: Product?, _ error: Error?) -> ())) {
        productRepository?.loadProduct(with: item, callback: callback)
    }
}
