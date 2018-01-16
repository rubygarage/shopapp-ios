//
//  AddressListDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class AddressListDelegate: NSObject, UITableViewDelegate {
    
    weak var delegate: AddressListHeaderViewProtocol?
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = AddressListTableHeaderView(frame: CGRect.zero)
        view.delegate = delegate
        return view
    }
}
