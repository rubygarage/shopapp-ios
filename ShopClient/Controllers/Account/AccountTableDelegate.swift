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
    func customer() -> Customer?
}

class AccountTableDelegate: NSObject, UITableViewDelegate {
    var delegate: (AccountTableDelegateProtocol & AccountNotLoggedHeaderProtocol & AccountLoggedHeaderProtocol & AccountFooterViewProtocol)!
    
    init(delegate: (AccountTableDelegateProtocol & AccountNotLoggedHeaderProtocol & AccountLoggedHeaderProtocol & AccountFooterViewProtocol)) {
        super.init()
        
        self.delegate = delegate
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let customer = delegate.customer() {
            return AccountLoggedHeaderView(customer: customer, delegate: delegate)
        } else {
            return AccountNotLoggedHeaderView(delegate: delegate)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return delegate?.customer() == nil ? UIView() : AccountFooterView(delegate: delegate)
    }
}
