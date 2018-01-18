//
//  CheckoutTableDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CheckoutTableDelegateProtocol: class {
    func checkout() -> Checkout?
}

class CheckoutTableDelegate: NSObject, UITableViewDelegate {
    weak var delegate: (SeeAllHeaderViewProtocol & CheckoutTableDelegateProtocol)?
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if delegate?.checkout() != nil, section == CheckoutSection.shippingOptions.rawValue {
            return PaymentDetailsFooterView.height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case CheckoutSection.cart.rawValue:
            let view = SeeAllTableHeaderView(type: .myCart, separatorVisible: true)
            view.delegate = delegate
            view.hideSeeAllButton()
            return view
        case CheckoutSection.shippingAddress.rawValue:
            return BoldTitleTableHeaderView(type: .shippingAddress)
        case CheckoutSection.payment.rawValue:
            return BoldTitleTableHeaderView(type: .payment)
        case CheckoutSection.shippingOptions.rawValue:
            let disabled = delegate?.checkout()?.availableShippingRates == nil
            return BoldTitleTableHeaderView(type: .shippingOptions, disabled: disabled)
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let checkout = delegate?.checkout(), section == CheckoutSection.shippingOptions.rawValue {
            return PaymentDetailsFooterView(checkout: checkout)
        }
        return nil
    }
}
