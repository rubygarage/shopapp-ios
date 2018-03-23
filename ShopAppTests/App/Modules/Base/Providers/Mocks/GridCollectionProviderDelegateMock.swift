//
//  GridCollectionProviderDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

@testable import ShopApp

class GridCollectionProviderDelegateMock: GridCollectionProviderDelegate {
    var provider: GridCollectionProvider?
    var product: Product?
    var scrollView: UIScrollView?
    
    // MARK: - GridCollectionProviderDelegate
    
    func provider(_ provider: GridCollectionProvider, didSelect product: Product) {
        self.provider = provider
        self.product = product
    }
    
    func provider(_ provider: GridCollectionProvider, didScroll scrollView: UIScrollView) {
        self.provider = provider
        self.scrollView = scrollView
    }
}
