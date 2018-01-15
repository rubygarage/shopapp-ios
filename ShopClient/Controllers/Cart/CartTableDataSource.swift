//
//  CartTableDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/9/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import SwipeCellKit

protocol CartTableDataSourceProtocol {
    func itemsCount() -> Int
    func item(for index: Int) -> CartProduct?
}

class CartTableDataSource: NSObject, UITableViewDataSource {
    
    weak var delegate: (CartTableDataSourceProtocol & CartTableCellProtocol & SwipeTableViewCellDelegate)?
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.itemsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CartTableViewCell.self), for: indexPath) as! CartTableViewCell
        cell.configure(with: delegate?.item(for: indexPath.row), delegate: delegate)
        
        return cell
    }
}
