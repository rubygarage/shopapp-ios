//
//  PopularTableCellProviderDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class PopularTableCellProviderDelegateMock: PopularTableCellProviderDelegate {
    var provider: PopularTableCellProvider?
    var product: Product?
    
    func provider(_ provider: PopularTableCellProvider, didSelect product: Product) {
        self.provider = provider
        self.product = product
    }
}
