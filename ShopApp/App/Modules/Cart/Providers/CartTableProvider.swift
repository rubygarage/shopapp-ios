//
//  CartTableProvider.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/29/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway
import SwipeCellKit

protocol CartTableProviderDelegate: class {
    func provider(_ provider: CartTableProvider, didSelect productVariant: ProductVariant)
}

class CartTableProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    let cartHeaderViewHeight: CGFloat = 76
    
    var cartProducts: [CartProduct] = []
    var totalPrice = Float(0)
    var currency = ""
    
    weak var delegate: (CartTableProviderDelegate & CartTableCellDelegate & SwipeTableViewCellDelegate)?
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        let cartProduct = cartProducts[indexPath.row]
        cell.configure(with: cartProduct)
        cell.cellDelegate = delegate
        cell.delegate = delegate
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate, let productVariant = cartProducts[indexPath.row].productVariant else {
            return
        }
        delegate.provider(self, didSelect: productVariant)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cartHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return CartHeaderView(productsCounts: cartProducts.count, totalPrice: totalPrice, currency: currency)
    }
}
