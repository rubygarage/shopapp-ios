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

class OrdersListTableDelegate: NSObject {
    weak var delegate: OrdersListTableDelegateProtocol?
}

// MARK: - UITableViewDelegate

extension OrdersListTableDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let orders = delegate?.orders() else {
            return nil
        }
        let order = orders[section]
        let view = OrderHeaderView(section: section, order: order)
        view.delegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let orders = delegate?.orders() else {
            return nil
        }
        let order = orders[section]
        let view = OrderFooterView(section: section, order: order)
        view.delegate = self
        return view
    }
}

// MARK: - OrderHeaderViewDelegate, OrderFooterViewDelegate

extension OrdersListTableDelegate: OrderHeaderViewDelegate, OrderFooterViewDelegate {
    func viewDidTap(_ section: Int) {
        delegate?.didSelectItem(at: section)
    }
}
