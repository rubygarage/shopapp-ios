//
//  AccountTableProvider.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/29/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

private enum AccountSection: Int {
    case customer
    case policy
    
    static let allValues = [customer, policy]
}

enum AccountCustomerSection: Int {
    case orders
    case info
    case addresses
    
    static let allValues = [orders, info, addresses]
}

protocol AccountTableProviderDelegate: class {
    func provider(_ provider: AccountTableProvider, didSelect type: AccountCustomerSection)
    func provider(_ provider: AccountTableProvider, didSelect policy: Policy)
}

class AccountTableProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let spaceBetweenSections: CGFloat = 10
    
    var policies: [Policy] = []
    var customer: Customer?
    var isOrdersEnabled: Bool
    
    weak var delegate: (AccountTableProviderDelegate & AccountNotLoggedHeaderDelegate & AccountFooterDelegate)?

    init(isOrdersEnabled: Bool) {
        self.isOrdersEnabled = isOrdersEnabled
    }
    
    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return AccountSection.allValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == AccountSection.customer.rawValue ? numberOfRowsInHeaderSection() : policies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AccountTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        
        switch indexPath.section {
        case AccountSection.customer.rawValue:
            let type = typeOfIndexPath(indexPath)
            cell.configure(with: type)
        default:
            let policy = policies[indexPath.row]
            cell.configure(with: policy)
        }
        
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }

        switch indexPath.section {
        case AccountSection.customer.rawValue:
            let type = typeOfIndexPath(indexPath)
            delegate.provider(self, didSelect: type)
        default:
            let policy = policies[indexPath.row]
            delegate.provider(self, didSelect: policy)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case AccountSection.customer.rawValue:
            return customer != nil ? kAccountLoggedHeaderViewHeight : kAccountNotLoggedHeaderViewHeight
        default:
            return spaceBetweenSections
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case AccountSection.customer.rawValue:
            return TableView.headerFooterMinHeight
        default:
            return customer != nil ? kAccountFooterViewHeight : TableView.headerFooterMinHeight
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == AccountSection.customer.rawValue else {
            return UIView()
        }
        
        if let customer = customer {
            let view = AccountLoggedHeaderView(frame: CGRect.zero, customer: customer)
            return view
        } else {
            let view = AccountNotLoggedHeaderView(frame: CGRect.zero)
            view.delegate = delegate
            return view
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == AccountSection.policy.rawValue, customer != nil else {
            return UIView()
        }
        let view: AccountFooterView = tableView.dequeueReusableHeaderFooterView()
        view.delegate = delegate
        return view
    }
    
    private func numberOfRowsInHeaderSection() -> Int {
        guard customer != nil else {
            return 0
        }
        
        var numberOfRows = AccountCustomerSection.allValues.count
        
        if !isOrdersEnabled {
            numberOfRows -= 1
        }
        
        return numberOfRows
    }
    
    private func typeOfIndexPath(_ indexPath: IndexPath) -> AccountCustomerSection {
        let index = isOrdersEnabled ? indexPath.row : indexPath.row + 1
        
        return AccountCustomerSection(rawValue: index)!
    }
}
