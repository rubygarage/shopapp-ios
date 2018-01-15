//
//  OrderDetailsTableDataSource.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/5/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

enum OrdersDetailsSection: Int {
    case header
    case paymentInformation
    case shippingAddress
    
    static let allValues = [header, paymentInformation, shippingAddress]
}

protocol OrdersDetailsTableDataSourceProtocol: class {
    func order() -> Order?
}

class OrdersDetailsTableDataSource: NSObject, UITableViewDataSource {
    
    weak var delegate: OrdersDetailsTableDataSourceProtocol?
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard delegate?.order() != nil else {
            return 0
        }
        
        return OrdersDetailsSection.allValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        switch section {
        case OrdersDetailsSection.paymentInformation.rawValue:
            numberOfRows = delegate?.order()?.items?.count ?? 0
        case OrdersDetailsSection.shippingAddress.rawValue:
            numberOfRows = delegate.order()!.shippingAddress != nil ? 1 : 0
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
    
    // MARK: - Private
    
    private func orderItemCell(with tableView: UITableView, indexPath: IndexPath) -> OrderItemTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OrderItemTableViewCell.self), for: indexPath) as! OrderItemTableViewCell
        if let order = delegate?.order(), let item = order.items?[indexPath.row] {
            cell.configure(with: item, currencyCode: order.currencyCode!)
        }
        return cell
    }
    
    private func shippingAddressCell(with tableView: UITableView, indexPath: IndexPath) -> CheckoutShippingAddressEditTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckoutShippingAddressEditTableCell.self), for: indexPath) as! CheckoutShippingAddressEditTableCell
        if let address = delegate?.order()?.shippingAddress {
            cell.configure(with: address)
            cell.editButton.isHidden = true
        }
        return cell
    }
}
