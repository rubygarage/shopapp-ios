//
//  CheckoutTableDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CheckoutTableDelegate: NSObject, UITableViewDelegate {
    var delegate: SeeAllHeaderViewProtocol!
    
    init(delegate: SeeAllHeaderViewProtocol) {
        super.init()
        
        self.delegate = delegate
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case CheckoutSection.cart.rawValue:
            return SeeAllTableHeaderView(delegate: delegate, type: .myCart, separatorVisible: true)
        case CheckoutSection.shippingAddress.rawValue:
            return BoldTitleTableHeaderView(type: .shippingAddress)
        case CheckoutSection.payment.rawValue:
            return BoldTitleTableHeaderView(type: .payment)
        default:
            return nil
        }
    }
}
