//
//  AccountTableProvider.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/29/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

protocol AccountTableProviderDelegate: class {
    func provider(_ provider: AccountTableProvider, didSelect policy: Policy)
}

class AccountTableProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    var policies: [Policy] = []
    var customer: Customer?
    
    weak var delegate: (AccountTableProviderDelegate & AccountNotLoggedHeaderDelegate & AccountLoggedHeaderDelegate & AccountFooterDelegate)?

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return policies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AccountTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        let policy = policies[indexPath.row]
        cell.configure(with: policy)
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }
        let policy = policies[indexPath.row]
        delegate.provider(self, didSelect: policy)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return customer != nil ? kAccountLoggedHeaderViewHeight : kAccountNotLoggedHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return customer != nil ? kAccountFooterViewHeight : TableView.headerFooterMinHeight
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
        let view: AccountFooterView = tableView.dequeueReusableHeaderFooterView()
        view.delegate = delegate
        return view
    }
}
