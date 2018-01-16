//
//  AddressListDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

typealias AddressTuple = (address: Address, selected: Bool)

protocol AddressListDataSourceProtocol {
    func itemsCount() -> Int
    func item(at index: Int) -> AddressTuple
}

class AddressListDataSource: NSObject, UITableViewDataSource {
    weak var delegate: (AddressListDataSourceProtocol & AddressListTableViewCellProtocol)?
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.itemsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AddressListTableViewCell.self), for: indexPath) as! AddressListTableViewCell

        if let addressTuple = delegate?.item(at: indexPath.row) {
            cell.configure(with: addressTuple.address, selected: addressTuple.selected)
        }
        
        cell.delegate = delegate
        return cell
    }
}
