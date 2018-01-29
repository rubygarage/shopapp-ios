//
//  AccountTableProvider.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/29/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol AccountTableProviderDelegate: class {
    func provider(_ provider: AccountTableProvider, didSelectItemAt index: Int)
}

class AccountTableProvider: NSObject {
    var policies: [Policy] = []
    var customer: Customer?
    
    weak var delegate: (AccountTableProviderDelegate & AccountNotLoggedHeaderDelegate & AccountLoggedHeaderDelegate & AccountFooterViewDelegate)?
}

// MARK: - UITableViewDataSource

extension AccountTableProvider: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return policies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AccountTableViewCell.self), for: indexPath) as! AccountTableViewCell
        let policy = policies[indexPath.row]
        cell.configure(with: policy)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AccountTableProvider: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.provider(self, didSelectItemAt: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let customer = customer {
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
        guard customer != nil else {
            return UIView()
        }
        let view = AccountFooterView(frame: CGRect.zero)
        view.delegate = delegate
        return view
    }
}
