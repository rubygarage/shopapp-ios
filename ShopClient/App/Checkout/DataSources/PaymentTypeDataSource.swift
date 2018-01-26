//
//  PaymentTypeDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol PaymentTypeDataSourceProtocol: class {
    func selectedPaymentType() -> PaymentType?
}

class PaymentTypeDataSource: NSObject, UITableViewDataSource {
    weak var delegate: PaymentTypeDataSourceProtocol?
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PaymentType.allValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PaymentTypeTableViewCell.self), for: indexPath) as! PaymentTypeTableViewCell
        let type = PaymentType(rawValue: indexPath.row)!
        let selected = delegate?.selectedPaymentType() == type
        cell.configure(with: type, selected: selected)
        return cell
    }
}
