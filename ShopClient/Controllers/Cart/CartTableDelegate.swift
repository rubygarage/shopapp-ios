//
//  CartTableDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

private let kFooterViewHeight: CGFloat = 100

protocol CartTableDelegateProtocol {
    func itemsCount() -> Int
    func totalPrice() -> Float
    func currency() -> String
}

class CartTableDelegate: NSObject, UITableViewDelegate {
    var delegate: (CartTableDelegateProtocol & CartFooterProtocol)?
    
    init(delegate: (CartTableDelegateProtocol & CartFooterProtocol)?) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let productsCount = delegate?.itemsCount() ?? 0
        let totalPrice: Float = delegate?.totalPrice() ?? 0
        let currency = delegate?.currency() ?? String()
        
        return CartFooterView(productsCounts: productsCount, totalPrice: totalPrice, currency: currency, delegate: delegate)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return kFooterViewHeight
    }
}
