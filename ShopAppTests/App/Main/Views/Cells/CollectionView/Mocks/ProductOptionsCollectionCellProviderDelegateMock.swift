//
//  ProductOptionsCollectionCellProviderDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

@testable import ShopApp

class ProductOptionsCollectionCellProviderDelegateMock: ProductOptionsCollectionCellProviderDelegate {
    var provider: ProductOptionsCollectionCellProvider?
    var value: String?
    
    func provider(_ provider: ProductOptionsCollectionCellProvider, didSelect value: String) {
        self.provider = provider
        self.value = value
    }
}
