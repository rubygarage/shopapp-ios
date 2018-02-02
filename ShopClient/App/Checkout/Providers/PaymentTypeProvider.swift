//
//  PaymentTypeProvider.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol PaymentTypeProviderDelegate: class {
    func provider(_ provider: PaymentTypeProvider, didSelect type: PaymentType)
}

class PaymentTypeProvider: NSObject {
    var selectedPaymentType: PaymentType?
    
    weak var delegate: PaymentTypeProviderDelegate?
}

// MARK: - UITableViewDataSource

extension PaymentTypeProvider: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PaymentType.allValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PaymentTypeTableViewCell.self), for: indexPath) as! PaymentTypeTableViewCell
        let type = PaymentType(rawValue: indexPath.row)!
        let selected = selectedPaymentType == type
        cell.configure(with: type, selected: selected)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PaymentTypeProvider: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate, let type = PaymentType(rawValue: indexPath.row) else {
            return
        }
        delegate.provider(self, didSelect: type)
    }
}
