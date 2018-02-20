//
//  BaseAddressListTableProvider.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

typealias AddressTuple = (address: Address, isSelected: Bool, isDefault: Bool)

class BaseAddressListTableProvider: NSObject {
    var addresses: [AddressTuple] = []
    var showSelectionButton = false
    
    weak var delegate: (AddressListTableCellDelegate & AddressListHeaderViewDelegate)?
}

// MARK: - UITableViewDataSource

extension BaseAddressListTableProvider: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddressListTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        let addressTuple = addresses[indexPath.row]
        cell.configure(with: addressTuple.address, isSelected: addressTuple.isSelected, isDefault: addressTuple.isDefault, showSelectionButton: showSelectionButton)
        cell.delegate = delegate
        return cell
    }
}

// MARK: - UITableViewDelegate

extension BaseAddressListTableProvider: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kAddressListTableHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = AddressListTableHeaderView(frame: CGRect.zero)
        view.delegate = delegate
        return view
    }
}
