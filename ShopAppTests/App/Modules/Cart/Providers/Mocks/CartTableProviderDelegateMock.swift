//
//  CartTableProviderDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/7/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

import ShopApp_Gateway
import SwipeCellKit

@testable import ShopApp

class CartTableProviderDelegateMock: NSObject, CartTableProviderDelegate, CartTableCellDelegate, SwipeTableViewCellDelegate {
    var selectedProductVariant: ProductVariant?
    
    // MARK: - CartTableProviderDelegate
    
    func provider(_ provider: CartTableProvider, didSelect productVariant: ProductVariant) {
        selectedProductVariant = productVariant
    }
    
    // MARK: - CartTableCellDelegate
    
    func tableViewCell(_ tableViewCell: CartTableViewCell, didUpdateCartProduct cartProduct: CartProduct, with quantity: Int) {}
    
    // MARK: - SwipeTableViewCellDelegate
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        return nil
    }
}
