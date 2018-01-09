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

protocol OrdersDetailsTableDataSourceProtocol {
    func order() -> Order?
}

class OrdersDetailsTableDataSource: NSObject, UITableViewDataSource {
    private var delegate: OrdersDetailsTableDataSourceProtocol!
    
    init(delegate: OrdersDetailsTableDataSourceProtocol) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let _ = delegate.order() else {
            return 0
        }
        
        return OrdersDetailsSection.allValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        switch section {
        case OrdersDetailsSection.header.rawValue:
            numberOfRows = 0
        case OrdersDetailsSection.paymentInformation.rawValue:
            numberOfRows = delegate.order()!.items!.count
        case OrdersDetailsSection.shippingAddress.rawValue:
            numberOfRows = 1
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
    
    // MARK: - private
    private func orderItemCell(with tableView: UITableView, indexPath: IndexPath) -> OrderItemTableViewCell {
        let item =  delegate.order()!.items![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OrderItemTableViewCell.self), for: indexPath) as! OrderItemTableViewCell
        cell.configure(with: item, currencyCode: delegate.order()!.currencyCode!)
        return cell
    }
    
    private func shippingAddressCell(with tableView: UITableView, indexPath: IndexPath) -> CheckoutShippingAddressEditTableCell {
        let address = delegate.order()!.shippingAddress!
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckoutShippingAddressEditTableCell.self), for: indexPath) as! CheckoutShippingAddressEditTableCell
        cell.configure(with: address)
        cell.editButton.isHidden = true
        return cell
    }
}
