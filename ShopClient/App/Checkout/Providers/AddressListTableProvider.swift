//
//  AddressListTableProvider.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

typealias AddressTuple = (address: Address, isSelected: Bool, isDefault: Bool)

class AddressListTableProvider: NSObject {
    var addresses: [AddressTuple] = []
    
    weak var delegate: (AddressListTableCellDelegate & AddressListHeaderViewDelegate)?
}

// MARK: - UITableViewDataSource

extension AddressListTableProvider: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellName = String(describing: AddressListTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! AddressListTableViewCell
        let addressTuple = addresses[indexPath.row]
        cell.configure(with: addressTuple.address, isSelected: addressTuple.isSelected, isDefault: addressTuple.isDefault)
        cell.delegate = delegate
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AddressListTableProvider: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kAddressListTableHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = AddressListTableHeaderView(frame: CGRect.zero)
        view.delegate = delegate
        return view
    }
}
