//
//  OrdersListTableDelegate.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol OrdersListTableDelegateProtocol {
    func orders() -> [Order]
    func didSelectItem(at index: Int)
}

class OrdersListTableDelegate: NSObject, UITableViewDelegate, OrderHeaderViewProtocol, OrderFooterViewProtocol {
    private var delegate: OrdersListTableDelegateProtocol!
    
    init(delegate: OrdersListTableDelegateProtocol) {
        super.init()
        
        self.delegate = delegate
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let orders = delegate.orders()
        let order = orders[section]
        return OrderHeaderView(section: section, order: order, delegate: self)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let orders = delegate.orders()
        let order = orders[section]
        return OrderFooterView(section: section, order: order, delegate: self)
    }
    // MARK: - OrderHeaderViewProtocol
    func viewDidTap(_ section: Int) {
        delegate.didSelectItem(at: section)
    }
}
