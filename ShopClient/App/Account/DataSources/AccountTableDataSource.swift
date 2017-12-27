//
//  AccountTableDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol AccountTableDataSourceProtocol {
    func policies() -> [Policy]
}

class AccountTableDataSource: NSObject, UITableViewDataSource {
    var delegate: AccountTableDataSourceProtocol!
    
    init(delegate: AccountTableDataSourceProtocol) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate.policies().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AccountTableViewCell.self), for: indexPath) as! AccountTableViewCell
        let policy = delegate.policies()[indexPath.row]
        cell.configure(with: policy)
        
        return cell
    }
}
