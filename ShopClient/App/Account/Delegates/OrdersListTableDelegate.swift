//
//  OrdersListTableDelegate.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol OrdersListTableDelegateProtocol: class {
    func orders() -> [Order]
    func didSelectItem(at index: Int)
}

class OrdersListTableDelegate: NSObject, UITableViewDelegate, OrderHeaderViewProtocol, OrderFooterViewProtocol {
    weak var delegate: OrdersListTableDelegateProtocol?
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let orders = delegate?.orders() {
            let order = orders[section]
            let view = OrderHeaderView(section: section, order: order)
            view.delegate = self
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let orders = delegate?.orders() {
            let order = orders[section]
            let view = OrderFooterView(section: section, order: order)
            view.delegate = self
            return view
        }
        return nil
    }
    
    // MARK: - OrderHeaderViewProtocol
    
    func viewDidTap(_ section: Int) {
        delegate?.didSelectItem(at: section)
    }
}
