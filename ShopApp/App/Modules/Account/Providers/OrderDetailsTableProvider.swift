//
//  OrderDetailsTableProvider.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/29/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

private enum OrderDetailsSection: Int {
    case header
    case paymentInformation
    case shippingAddress
    
    static let allValues = [header, paymentInformation, shippingAddress]
}

protocol OrderDetailsTableProviderDelegate: class {
    func provider(_ provider: OrderDetailsTableProvider, didSelect productVariant: ProductVariant)
}

class OrderDetailsTableProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    var order: Order?
    
    weak var delegate: OrderDetailsTableProviderDelegate?

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        guard order != nil else {
            return 0
        }
        
        return OrderDetailsSection.allValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let order = order else {
            return 0
        }
        
        var numberOfRows = 0
        
        switch section {
        case OrderDetailsSection.paymentInformation.rawValue:
            numberOfRows = order.items?.count ?? 0
        case OrderDetailsSection.shippingAddress.rawValue:
            numberOfRows = order.shippingAddress != nil ? 1 : 0
        default:
            break
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.section {
        case OrderDetailsSection.paymentInformation.rawValue:
            cell = orderItemCell(with: tableView, indexPath: indexPath)
        case OrderDetailsSection.shippingAddress.rawValue:
            cell = shippingAddressCell(with: tableView, indexPath: indexPath)
        default:
            break
        }
        
        return cell
    }
    
    private func orderItemCell(with tableView: UITableView, indexPath: IndexPath) -> OrderItemTableViewCell {
        let cell: OrderItemTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        if let order = order, let item = order.items?[indexPath.row], let currencyCode = order.currencyCode {
            cell.configure(with: item, currencyCode: currencyCode)
        }
        return cell
    }
    
    private func shippingAddressCell(with tableView: UITableView, indexPath: IndexPath) -> CheckoutShippingAddressEditTableCell {
        let cell: CheckoutShippingAddressEditTableCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        if let address = order?.shippingAddress {
            cell.configure(with: address)
            cell.setEditButtonVisible(false)
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate, indexPath.section == OrderDetailsSection.paymentInformation.rawValue, let order = order, let item = order.items?[indexPath.row], let productVariant = item.productVariant else {
            return
        }
        delegate.provider(self, didSelect: productVariant)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == OrderDetailsSection.header.rawValue ? kOrderHeaderViewHeight : kBoldTitleTableHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == OrderDetailsSection.paymentInformation.rawValue ? kPaymentDetailsFooterViewHeight : TableView.headerFooterMinHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView()
        
        switch section {
        case OrderDetailsSection.header.rawValue:
            if let order = order {
                view = OrderHeaderView(section: section, order: order)
            }
        case OrderDetailsSection.paymentInformation.rawValue:
            view = BoldTitleTableHeaderView(type: .details)
        case OrderDetailsSection.shippingAddress.rawValue:
            if order?.shippingAddress != nil {
                view = BoldTitleTableHeaderView(type: .shippingAddress)
            }
        default:
            break
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let order = order, section == OrderDetailsSection.paymentInformation.rawValue else {
            return nil
        }
        return PaymentDetailsFooterView(order: order)
    }
}
