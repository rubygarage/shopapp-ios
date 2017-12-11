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

private let kHeaderHeightLogged: CGFloat = 184
private let kHeaderHeightNotLogged: CGFloat = 179

class AccountTableDelegate: NSObject, UITableViewDelegate {
    var delegate: (AccountTableDelegateProtocol & AccountNotLoggedHeaderProtocol & AccountLoggedHeaderProtocol)!
    
    init(delegate: (AccountTableDelegateProtocol & AccountNotLoggedHeaderProtocol & AccountLoggedHeaderProtocol)) {
        super.init()
        
        self.delegate = delegate
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return delegate.customer() != nil ? kHeaderHeightLogged : kHeaderHeightNotLogged
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let customer = delegate.customer() {
            return AccountLoggedHeaderView(customer: customer, delegate: delegate)
        } else {
            return AccountNotLoggedHeaderView(delegate: delegate)
        }
    }
}
