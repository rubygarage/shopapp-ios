//
//  ShopCoreAPI.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 8/30/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ShopCoreAPI {
    
    // MARK: - singleton
    static let shared = ShopCoreAPI()
    var shopAPI: ShopAPIProtocol?
    
    // MARK: - setup
    func setup(shopAPI: ShopAPIProtocol) {
        self.shopAPI = shopAPI
    }
    
    // MARK: - user methods    
    func getArticleList(perPage: Int = kItemsPerPage, paginationValue: Any? = nil, sortBy: SortingValue? = nil, reverse: Bool = false, callback: @escaping ApiCallback<[Article]>) {
        shopAPI?.getArticleList(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, reverse: reverse, callback: callback)
    }
}
