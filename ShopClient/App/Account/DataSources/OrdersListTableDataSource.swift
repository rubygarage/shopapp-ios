//
//  OrdersListTableDataSource.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol OrdersListTableDataSourceProtocol: class {
    func orders() -> [Order]
}

class OrdersListTableDataSource: NSObject, UITableViewDataSource {
    
    weak var delegate: (OrdersListTableDataSourceProtocol & CheckoutCartTableViewCellDelegate)?
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return delegate?.orders().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckoutCartTableViewCell.self), for: indexPath) as! CheckoutCartTableViewCell
        if let orders = delegate?.orders() {
            var images = [Image]()
            var productVariantIds = [String]()
            let order = orders[indexPath.section]
            if let items = order.items {
                images = items.map { $0.productVariant?.image ?? Image() }
                productVariantIds = items.map { $0.productVariant?.id ?? "" }
            }
            cell.configure(with: images, productVariantIds: productVariantIds, index: indexPath.section)
        }
        cell.cellDelegate = delegate
        return cell
    }
}
