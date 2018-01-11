//
//  PaymentTypeDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

enum PaymentTypeSection: Int {
    case creditCard
    case applePay
    
    static let allValues = [creditCard, applePay]
}

class PaymentTypeDataSource: NSObject, UITableViewDataSource {
    weak var delegate: PaymentTypeTableCellProtocol?
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PaymentTypeSection.allValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case PaymentTypeSection.creditCard.rawValue:
            return paymentCreditCardCell(tableView: tableView, indexPath: indexPath)
        default:
            return paymentApplePayCell(tableView: tableView, indexPath: indexPath)
        }
    }
    
    // MARK: - private
    private func paymentCreditCardCell(tableView: UITableView, indexPath: IndexPath) -> PaymentCreditCardTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PaymentCreditCardTableCell.self), for: indexPath) as! PaymentCreditCardTableCell
        cell.delegate = delegate
        return cell
    }
    
    private func paymentApplePayCell(tableView: UITableView, indexPath: IndexPath) -> PaymentApplePayTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PaymentApplePayTableCell.self), for: indexPath) as! PaymentApplePayTableCell
        
        return cell
    }
}
