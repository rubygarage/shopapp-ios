//
//  CheckoutTableDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CheckoutTableDelegateProtocol {
    func checkout() -> Checkout?
}

class CheckoutTableDelegate: NSObject, UITableViewDelegate {
    private var delegate: (SeeAllHeaderViewProtocol & CheckoutTableDelegateProtocol)!
    
    init(delegate: SeeAllHeaderViewProtocol & CheckoutTableDelegateProtocol) {
        super.init()
        
        self.delegate = delegate
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if delegate.checkout() != nil, section == CheckoutSection.payment.rawValue {
            return PaymentDetailsFooterView.height
        }
        return 0
    }
    
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let checkout = delegate.checkout(), section == CheckoutSection.payment.rawValue {
            return PaymentDetailsFooterView(checkout: checkout)
        }
        return nil
    }
}
