//
//  OrderListTableProvider.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/29/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol OrdersListTableProviderDelegate: class {
    func provider(_ provider: OrdersListTableProvider, didSelect order: Order)
}

class OrdersListTableProvider: NSObject {
    var orders: [Order] = []
    
    weak var delegate: (OrdersListTableProviderDelegate & CheckoutCartTableViewCellDelegate)?
    
    fileprivate func selectOrder(at index: Int) {
        guard let delegate = delegate else {
            return
        }
        let order = orders[index]
        delegate.provider(self, didSelect: order)
    }
}

// MARK: - UITableViewDataSource

extension OrdersListTableProvider: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellName = String(describing: CheckoutCartTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! CheckoutCartTableViewCell
        var images: [Image] = []
        var productVariantIds: [String] = []
        let order = orders[indexPath.section]
        if let items = order.items {
            images = items.map { $0.productVariant?.image ?? Image() }
            productVariantIds = items.map { $0.productVariant?.id ?? "" }
        }
        cell.configure(with: images, productVariantIds: productVariantIds, index: indexPath.section)
        cell.cellDelegate = delegate
        return cell
    }
}

// MARK: - UITableViewDelegate

extension OrdersListTableProvider: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !orders.isEmpty else {
            return nil
        }
        let view = OrderHeaderView(section: section, order: orders[section])
        view.delegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard !orders.isEmpty else {
            return nil
        }
        let view = OrderFooterView(section: section, order: orders[section])
        view.delegate = self
        return view
    }
}

// MARK: - OrderHeaderViewDelegate

extension OrdersListTableProvider: OrderHeaderDelegate {
    func headerView(_ headerView: OrderHeaderView, didTapWith section: Int) {
        selectOrder(at: section)
    }
}

// MARK: - OrderFooterViewDelegate

extension OrdersListTableProvider: OrderFooterDelegate {
    func footerView(_ footerView: OrderFooterView, didTapWith section: Int) {
        selectOrder(at: section)
    }
}
