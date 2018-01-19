//
//  PaymentTypeDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/18/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol PaymentTypeDelegateProtocol: class {
    func didSelectPayment(type: PaymentTypeSection)
}

class PaymentTypeDelegate: NSObject, UITableViewDelegate {
    weak var delegate: PaymentTypeDelegateProtocol?
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let type = PaymentTypeSection(rawValue: indexPath.row) {
            delegate?.didSelectPayment(type: type)
        }
    }
}
