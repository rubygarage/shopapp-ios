//
//  CategoryListCollectionProviderDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

@testable import ShopApp

class CategoryListCollectionProviderDelegateMock: NSObject, CategoryListCollectionProviderDelegate {
    var provider: CategoryListCollectionProvider?
    var category: ShopApp_Gateway.Category?
    
    // MARK: - CategoryListCollectionProviderDelegate
    
    func provider(_ provider: CategoryListCollectionProvider, didSelect category: ShopApp_Gateway.Category) {
        self.provider = provider
        self.category = category
    }
}
