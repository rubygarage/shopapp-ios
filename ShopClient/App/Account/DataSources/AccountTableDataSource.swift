//
//  AccountTableDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol AccountTableDataSourceProtocol: class {
    func policies() -> [Policy]
}

class AccountTableDataSource: NSObject {
    weak var delegate: AccountTableDataSourceProtocol?
}

// MARK: - UITableViewDataSource

extension AccountTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.policies().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AccountTableViewCell.self), for: indexPath) as! AccountTableViewCell
        if let policy = delegate?.policies()[indexPath.row] {
            cell.configure(with: policy)
        }
        return cell
    }
}
