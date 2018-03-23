//
//  CartEmptyDataViewDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

@testable import ShopApp

class CartEmptyDataViewDelegateMock: CartEmptyDataViewDelegate {
    var view: CartEmptyDataView?
    
    // MARK: - CartEmptyDataViewDelegate
    
    func viewDidTapStartShopping(_ view: CartEmptyDataView) {
        self.view = view
    }
}
