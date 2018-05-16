//
//  CartTableCellDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit
import ShopApp_Gateway

@testable import ShopApp

class CartTableCellDelegateMock: NSObject, CartTableCellDelegate {
    var cell: CartTableViewCell!
    var updatedCartProduct: CartProduct!
    var updatedQuantity = 0
    
    func tableViewCell(_ tableViewCell: CartTableViewCell, didUpdateCartProduct cartProduct: CartProduct, with quantity: Int) {
        cell = tableViewCell
        updatedCartProduct = cartProduct
        updatedQuantity = quantity
    }
    
    func tableViewCell(_ tableViewCell: CartTableViewCell, didSelectMoreFor cartProduct: CartProduct, with quantity: Int) {
        cell = tableViewCell
        updatedCartProduct = cartProduct
        updatedQuantity = quantity
    }
}
