//
//  AccountTableDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol AccountTableDelegateProtocol {
    func didSelectItem(at index: Int)
}

class AccountTableDelegate: NSObject, UITableViewDelegate {
    var delegate: AccountTableDelegateProtocol!
    
    init(delegate: AccountTableDelegateProtocol) {
        super.init()
        
        self.delegate = delegate
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath.row)
    }
}
