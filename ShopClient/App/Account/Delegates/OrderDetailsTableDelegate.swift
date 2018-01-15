//
//  OrderDetailsTableDelegate.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/5/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol OrdersDetailsTableDelegateProtocol {
    func order() -> Order?
    func didSelectItem(at index: Int)
}

class OrdersDetailsTableDelegate: NSObject, UITableViewDelegate {
    private var delegate: OrdersDetailsTableDelegateProtocol!
    
    init(delegate: OrdersDetailsTableDelegateProtocol) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView()
        
        switch section {
        case OrdersDetailsSection.header.rawValue:
            view = OrderHeaderView(section: section, order: delegate.order()!)
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
        return section == OrdersDetailsSection.paymentInformation.rawValue ? PaymentDetailsFooterView(order: delegate.order()!) : nil
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
