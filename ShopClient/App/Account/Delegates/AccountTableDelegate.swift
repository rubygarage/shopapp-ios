//
//  AccountTableDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol AccountTableDelegateProtocol: class {
    func didSelectItem(at index: Int)
    func customer() -> Customer?
}

class AccountTableDelegate: NSObject {
    weak var delegate: (AccountTableDelegateProtocol & AccountNotLoggedHeaderDelegate & AccountLoggedHeaderDelegate & AccountFooterViewDelegate)?
}

// MARK: - UITableViewDelegate

extension AccountTableDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let customer = delegate?.customer() {
            let view = AccountLoggedHeaderView(frame: CGRect.zero, customer: customer)
            view.delegate = delegate
            return view
        } else {
            let view = AccountNotLoggedHeaderView(frame: CGRect.zero)
            view.delegate = delegate
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard delegate?.customer() != nil else {
            return UIView()
        }
        let view = AccountFooterView(frame: CGRect.zero)
        view.delegate = delegate
        return view
    }
}
