//
//  AddressListDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class AddressListDelegate: NSObject, UITableViewDelegate {
    private var delegate: AddressListHeaderViewProtocol!
    
    init(delegate: AddressListHeaderViewProtocol) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return AddressListTableHeaderView(delegate: delegate)
    }
}
