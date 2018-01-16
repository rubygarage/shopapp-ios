//
//  PaymentTypeDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

enum PaymentTypeSection {
    case creditCard
    
    static let allValues = [creditCard]
}

class PaymentTypeDataSource: NSObject, UITableViewDataSource {
    weak var delegate: PaymentTypeTableCellProtocol?
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PaymentTypeSection.allValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PaymentTypeTableCell.self), for: indexPath) as! PaymentTypeTableCell
        cell.delegate = delegate
        return cell
    }
}
