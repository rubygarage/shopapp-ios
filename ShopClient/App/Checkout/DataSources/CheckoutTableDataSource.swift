//
//  CheckoutTableDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CheckoutCombinedProtocol: CheckoutTableDataSourceProtocol, CheckoutShippingAddressAddCellProtocol, CheckoutShippingAddressEditCellProtocol, CheckoutPaymentAddCellProtocol, CheckoutTableDelegateProtocol {}

protocol CheckoutTableDataSourceProtocol {
    func cartProducts() -> [CartProduct]
    func shippingAddress() -> Address?
    func billingAddress() -> Address?
    func creditCard() -> CreditCard?
}

class CheckoutTableDataSource: NSObject, UITableViewDataSource {
    private var delegate: CheckoutCombinedProtocol!
    
    init(delegate: CheckoutCombinedProtocol) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return CheckoutSection.allValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case CheckoutSection.cart.rawValue:
            return cartCell(with: tableView, indexPath: indexPath)
        case CheckoutSection.shippingAddress.rawValue:
            return shippingAddressCell(with: tableView, indexPath: indexPath)
        case CheckoutSection.payment.rawValue:
            return paymentCell(with: tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - private
    private func cartCell(with tableView: UITableView, indexPath: IndexPath) -> CheckoutCartTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckoutCartTableViewCell.self), for: indexPath) as! CheckoutCartTableViewCell
        let images = delegate.cartProducts().flatMap { $0.productVariant?.image }
        cell.configure(with: images)
        return cell
    }
    
    private func shippingAddressCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let shippingAddress = delegate.shippingAddress() {
            return shippingAddressEditCell(with: tableView, indexPath: indexPath, address: shippingAddress)
        } else {
            return shippingAddressAddCell(with: tableView, indexPath: indexPath)
        }
    }
    
    private func shippingAddressAddCell(with tableView: UITableView, indexPath: IndexPath) -> CheckoutShippingAddressAddTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckoutShippingAddressAddTableCell.self), for: indexPath) as! CheckoutShippingAddressAddTableCell
        cell.delegate = delegate
        return cell
    }
    
    private func shippingAddressEditCell(with tableView: UITableView, indexPath: IndexPath, address: Address) -> CheckoutShippingAddressEditTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckoutShippingAddressEditTableCell.self), for: indexPath) as! CheckoutShippingAddressEditTableCell
        cell.configure(with: address, delegate: delegate)
        return cell
    }
    
    private func paymentCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let address = delegate.billingAddress(), let card = delegate.creditCard() {
            return paymentEditCell(with: tableView, indexPath: indexPath, billingAddress: address, creditCard: card)
        } else {
            return paymentAddCell(with: tableView, indexPath: indexPath)
        }
    }
    
    private func paymentAddCell(with tableView: UITableView, indexPath: IndexPath) -> CheckoutPaymentAddTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckoutPaymentAddTableCell.self), for: indexPath) as! CheckoutPaymentAddTableCell
        cell.delegate = delegate
        return cell
    }
    
    private func paymentEditCell(with tableView: UITableView, indexPath: IndexPath, billingAddress: Address, creditCard: CreditCard) -> CheckoutPaymentEditTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckoutPaymentEditTableCell.self), for: indexPath) as! CheckoutPaymentEditTableCell
        cell.configure(with: billingAddress, creditCard: creditCard)
        return cell
    }
}
