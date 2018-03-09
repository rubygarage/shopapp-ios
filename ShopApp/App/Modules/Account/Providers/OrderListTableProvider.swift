//
//  OrderListTableProvider.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/29/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

protocol OrderListTableProviderDelegate: class {
    func provider(_ provider: OrderListTableProvider, didSelect order: Order)
}

class OrderListTableProvider: NSObject, UITableViewDataSource, UITableViewDelegate, OrderHeaderDelegate, OrderFooterDelegate {
    var orders: [Order] = []
    
    weak var delegate: (OrderListTableProviderDelegate & CheckoutCartTableViewCellDelegate)?
    
    fileprivate func selectOrder(at index: Int) {
        guard let delegate = delegate else {
            return
        }
        let order = orders[index]
        delegate.provider(self, didSelect: order)
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CheckoutCartTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
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

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kOrderHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return kOrderFooterViewHeight
    }
    
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

    // MARK: - OrderHeaderViewDelegate

    func headerView(_ headerView: OrderHeaderView, didTapWith section: Int) {
        selectOrder(at: section)
    }

    // MARK: - OrderFooterViewDelegate

    func footerView(_ footerView: OrderFooterView, didTapWith section: Int) {
        selectOrder(at: section)
    }
}
