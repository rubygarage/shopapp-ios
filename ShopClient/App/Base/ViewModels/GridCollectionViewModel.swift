//
//  GridCollectionViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/3/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

import ShopClient_Gateway

class GridCollectionViewModel: BasePaginationViewModel {
    var products = Variable<[Product]>([])
    
    func updateProducts(products: [Product]) {
        if paginationValue == nil {
            self.products.value.removeAll()
        }
        self.products.value += products
    }
}
