//
//  CartTableDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CartTableDelegateProtocol: class {
    func itemsCount() -> Int
    func totalPrice() -> Float
    func currency() -> String
    func didSelectItem(at index: Int)
}

class CartTableDelegate: NSObject {
    weak var delegate: CartTableDelegateProtocol?
}

// MARK: - UITableViewDelegate

extension CartTableDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let delegate = delegate else {
            return nil
        }
        return CartHeaderView(productsCounts: delegate.itemsCount(), totalPrice: delegate.totalPrice(), currency: delegate.currency())
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath.row)
    }
}
