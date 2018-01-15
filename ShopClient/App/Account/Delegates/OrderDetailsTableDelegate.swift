//
//  OrderDetailsTableDelegate.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/5/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol OrdersDetailsTableDelegateProtocol: class {
    func order() -> Order?
    func didSelectItem(at index: Int)
}

class OrdersDetailsTableDelegate: NSObject, UITableViewDelegate {
    
    weak var delegate: OrdersDetailsTableDelegateProtocol?
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView()
        
        switch section {
        case OrdersDetailsSection.header.rawValue:
            if let order = delegate?.order() {
                view = OrderHeaderView(section: section, order: order)
            }
        case OrdersDetailsSection.paymentInformation.rawValue:
            view = BoldTitleTableHeaderView(type: .paymentInformation)
        case OrdersDetailsSection.shippingAddress.rawValue:
            if delegate.order()!.shippingAddress != nil {
                view = BoldTitleTableHeaderView(type: .shippingAddress)
            }
        default:
            break
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let order = delegate?.order(), section == OrdersDetailsSection.paymentInformation.rawValue {
            return PaymentDetailsFooterView(order: order)
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == OrdersDetailsSection.paymentInformation.rawValue ? PaymentDetailsFooterView.height : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == OrdersDetailsSection.paymentInformation.rawValue {
            delegate?.didSelectItem(at: indexPath.row)
        }
    }
 
}
