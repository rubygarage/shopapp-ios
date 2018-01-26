//
//  CheckoutTableDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CheckoutCombinedProtocol: CheckoutTableDataSourceProtocol, CheckoutShippingAddressAddCellProtocol, CheckoutShippingAddressEditCellProtocol, CheckoutPaymentAddCellProtocol, CheckoutTableDelegateProtocol, CheckoutCartTableViewCellDelegate, CheckoutCreditCardEditTableCellProtocol, CheckoutShippingOptionsEnabledTableCellProtocol, PaymentTypeViewControllerProtocol, CheckoutSelectedTypeTableCellProtocol, CheckoutBillingAddressEditCellProtocol {}

protocol CheckoutTableDataSourceProtocol: class {
    func cartProducts() -> [CartProduct]
    func shippingAddress() -> Address?
    func billingAddress() -> Address?
    func creditCard() -> CreditCard?
    func availableShippingRates() -> [ShippingRate]?
    func selectedPaymentType() -> PaymentType?
}

class CheckoutTableDataSource: NSObject, UITableViewDataSource {
    weak var delegate: CheckoutCombinedProtocol?
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return delegate?.selectedPaymentType() == .creditCard ? CheckoutSection.allValues.count : CheckoutSection.valuesWithoutShippingOptions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == CheckoutSection.shippingOptions.rawValue {
            return delegate?.availableShippingRates()?.count ?? 1
        } else if section == CheckoutSection.payment.rawValue {
            return delegate?.selectedPaymentType() == .creditCard ? PaymentAddCellType.allValues.count : 1
        }
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
        case CheckoutSection.shippingOptions.rawValue:
            return shippingOptionsCell(with: tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - Private
    
    private func cartCell(with tableView: UITableView, indexPath: IndexPath) -> CheckoutCartTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckoutCartTableViewCell.self), for: indexPath) as! CheckoutCartTableViewCell
        if let images = delegate?.cartProducts().map({ $0.productVariant?.image ?? Image() }), let productVariantIds = delegate?.cartProducts().map({ $0.productVariant?.id ?? "" }) {
            cell.configure(with: images, productVariantIds: productVariantIds)
            cell.cellDelegate = delegate
        }
        return cell
    }
    
    private func shippingAddressCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let shippingAddress = delegate?.shippingAddress() {
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
        cell.delegate = delegate
        cell.configure(with: address)
        return cell
    }
    
    private func paymentCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case PaymentAddCellType.type.rawValue:
            return paymentTypeCell(with: tableView, indexPath: indexPath)
        case PaymentAddCellType.card.rawValue:
            return paymentCardCell(with: tableView, indexPath: indexPath)
        case PaymentAddCellType.billingAddress.rawValue:
            return paymentBillingAddressCell(with: tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    private func paymentTypeCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let selectedType = delegate?.selectedPaymentType() {
            return paymentEditCell(with: tableView, indexPath: indexPath, selectedType: selectedType)
        } else {
            return paymentAddCell(with: tableView, indexPath: indexPath)
        }
    }
    
    private func paymentAddCell(with tableView: UITableView, indexPath: IndexPath) -> CheckoutPaymentAddTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckoutPaymentAddTableCell.self), for: indexPath) as! CheckoutPaymentAddTableCell
        cell.delegate = delegate
        let type = PaymentAddCellType(rawValue: indexPath.row)
        cell.configure(type: type!)
        return cell
    }
    
    private func paymentEditCell(with tableView: UITableView, indexPath: IndexPath, selectedType: PaymentType) -> CheckoutSelectedTypeTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckoutSelectedTypeTableCell.self), for: indexPath) as! CheckoutSelectedTypeTableCell
        cell.delegate = delegate
        cell.configure(type: selectedType)
        return cell
    }
    
    private func paymentCardCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let card = delegate?.creditCard() {
            return paymentCardEditCell(with: tableView, indexPath: indexPath, creditCard: card)
        } else {
            return paymentAddCell(with: tableView, indexPath: indexPath)
        }
    }
    
    private func paymentCardEditCell(with tableView: UITableView, indexPath: IndexPath, creditCard: CreditCard) -> CheckoutCreditCardEditTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckoutCreditCardEditTableCell.self), for: indexPath) as! CheckoutCreditCardEditTableCell
        cell.delegate = delegate
        cell.configure(with: creditCard)
        return cell
    }
    
    private func paymentBillingAddressCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let address = delegate?.billingAddress() {
            return paymentBillingAddressEditCell(with: tableView, indexPath: indexPath, address: address)
        } else {
            return paymentAddCell(with: tableView, indexPath: indexPath)
        }
    }
    
    private func paymentBillingAddressEditCell(with tableView: UITableView, indexPath: IndexPath, address: Address) -> CheckoutBillingAddressEditTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckoutBillingAddressEditTableCell.self), for: indexPath) as! CheckoutBillingAddressEditTableCell
        cell.delegate = delegate
        cell.configure(with: address)
        return cell
    }
    
    private func shippingOptionsCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if delegate?.shippingAddress() != nil, let rates = delegate?.availableShippingRates(), let currencyCode = delegate?.checkout()?.currencyCode {
            let rate = rates[indexPath.row]
            let selected = delegate?.checkout()?.shippingLine?.handle == rate.handle
            return shippingOptionsEnabledCell(with: tableView, indexPath: indexPath, rate: rate, currencyCode: currencyCode, selected: selected)
        } else {
            return shippingOptionsDisabledCell(with: tableView, indexPath: indexPath)
        }
    }
    
    private func shippingOptionsEnabledCell(with tableView: UITableView, indexPath: IndexPath, rate: ShippingRate, currencyCode: String, selected: Bool) -> CheckoutShippingOptionsEnabledTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckoutShippingOptionsEnabledTableCell.self), for: indexPath) as! CheckoutShippingOptionsEnabledTableCell
        cell.delegate = delegate
        cell.configure(with: rate, currencyCode: currencyCode, selected: selected)
        return cell
    }
    
    private func shippingOptionsDisabledCell(with tableView: UITableView, indexPath: IndexPath) -> CheckoutShippingOptionsDisabledTableCell {
        return tableView.dequeueReusableCell(withIdentifier: String(describing: CheckoutShippingOptionsDisabledTableCell.self), for: indexPath) as! CheckoutShippingOptionsDisabledTableCell
    }
}
