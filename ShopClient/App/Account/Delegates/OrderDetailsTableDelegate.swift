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
            view = BoldTitleTableHeaderView(type: .shippingAddress)
        default:
            break
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var view: UIView? = nil
        
        switch section {
        case OrdersDetailsSection.paymentInformation.rawValue:
            view = PaymentDetailsFooterView(order: delegate.order()!)
        default:
            break
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var height = CGFloat(0)
        
        switch section {
        case OrdersDetailsSection.paymentInformation.rawValue:
            height = PaymentDetailsFooterView.height
        default:
            break
        }
        
        return height
    }
 
}
