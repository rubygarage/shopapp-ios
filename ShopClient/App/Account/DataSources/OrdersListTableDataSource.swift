//
//  OrdersListTableDataSource.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol OrdersListTableDataSourceProtocol {
    func orders() -> [Order]
}

class OrdersListTableDataSource: NSObject, UITableViewDataSource {
    private var delegate: OrdersListTableDataSourceProtocol!
    
    init(delegate: OrdersListTableDataSourceProtocol) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return delegate.orders().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckoutCartTableViewCell.self), for: indexPath) as! CheckoutCartTableViewCell
        let orders = delegate.orders()
        let order = orders[indexPath.section]
        let items = order.items
        let images = items != nil ? items!.map { $0.productVariant?.image ?? Image() } : [Image]()
        cell.configure(with: images)
        return cell
    }
}
