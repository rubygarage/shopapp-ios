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
    private var delegate: PaymentTypeTableCellProtocol?
    
    init(with delegate: PaymentTypeTableCellProtocol?) {
        super.init()
        
        self.delegate = delegate
    }
    
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
