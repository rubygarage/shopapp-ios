//
//  LastArrivalsTableCellProviderDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class LastArrivalsTableCellProviderDelegateMock: LastArrivalsTableCellProviderDelegate {
    var provider: LastArrivalsTableCellProvider?
    var product: Product?
    
    func provider(_ provider: LastArrivalsTableCellProvider, didSelect product: Product) {
        self.provider = provider
        self.product = product
    }
}
