//
//  OrderDetailsTableProvider.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/29/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

private enum OrdersDetailsSection: Int {
    case header
    case paymentInformation
    case shippingAddress
    
    static let allValues = [header, paymentInformation, shippingAddress]
}

protocol OrdersDetailsTableProviderDelegate: class {
    func provider(_ provider: OrdersDetailsTableProvider, didSelect productVariant: ProductVariant)
}

class OrdersDetailsTableProvider: NSObject {
    var order: Order?
    
    weak var delegate: OrdersDetailsTableProviderDelegate?
}

// MARK: - UITableViewDataSource

extension OrdersDetailsTableProvider: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard order != nil else {
            return 0
        }
        
        return OrdersDetailsSection.allValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let order = order else {
            return 0
        }
        
        var numberOfRows = 0
        
        switch section {
        case OrdersDetailsSection.paymentInformation.rawValue:
            numberOfRows = order.items?.count ?? 0
        case OrdersDetailsSection.shippingAddress.rawValue:
            numberOfRows = order.shippingAddress != nil ? 1 : 0
        default:
            break
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.section {
        case OrdersDetailsSection.paymentInformation.rawValue:
            cell = orderItemCell(with: tableView, indexPath: indexPath)
        case OrdersDetailsSection.shippingAddress.rawValue:
            cell = shippingAddressCell(with: tableView, indexPath: indexPath)
        default:
            break
        }
        
        return cell
    }
    
    private func orderItemCell(with tableView: UITableView, indexPath: IndexPath) -> OrderItemTableViewCell {
        let cellName = String(describing: OrderItemTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! OrderItemTableViewCell
        if let order = order, let item = order.items?[indexPath.row], let currencyCode = order.currencyCode {
            cell.configure(with: item, currencyCode: currencyCode)
        }
        return cell
    }
    
    private func shippingAddressCell(with tableView: UITableView, indexPath: IndexPath) -> CheckoutShippingAddressEditTableCell {
        let cellName = String(describing: CheckoutShippingAddressEditTableCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! CheckoutShippingAddressEditTableCell
        if let address = order?.shippingAddress {
            cell.configure(with: address)
            cell.setEditButtonVisible(false)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension OrdersDetailsTableProvider: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate, indexPath.section == OrdersDetailsSection.paymentInformation.rawValue, let order = order, let item = order.items?[indexPath.row], let productVariant = item.productVariant else {
            return
        }
        delegate.provider(self, didSelect: productVariant)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == OrdersDetailsSection.header.rawValue ? kOrderHeaderViewHeight : kBoldTitleTableHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == OrdersDetailsSection.paymentInformation.rawValue ? kPaymentDetailsFooterViewHeight : TableView.headerFooterMinHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView()
        
        switch section {
        case OrdersDetailsSection.header.rawValue:
            if let order = order {
                view = OrderHeaderView(section: section, order: order)
            }
        case OrdersDetailsSection.paymentInformation.rawValue:
            view = BoldTitleTableHeaderView(type: .paymentInformation)
        case OrdersDetailsSection.shippingAddress.rawValue:
            if order?.shippingAddress != nil {
                view = BoldTitleTableHeaderView(type: .shippingAddress)
            }
        default:
            break
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let order = order, section == OrdersDetailsSection.paymentInformation.rawValue else {
            return nil
        }
        return PaymentDetailsFooterView(order: order)
    }
}
