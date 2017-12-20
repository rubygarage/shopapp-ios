//
//  CheckoutTableDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CheckoutTableDataSourceProtocol {
    func cartProducts() -> [CartProduct]
}

class CheckoutTableDataSource: NSObject, UITableViewDataSource {
    var delegate: CheckoutTableDataSourceProtocol!
    
    init(delegate: CheckoutTableDataSourceProtocol) {
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
        let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: CheckoutCartTableViewCell.self), for: indexPath) as! CheckoutCartTableViewCell
        cell.configure(with: delegate.cartProducts())
        return cell
    }
}
