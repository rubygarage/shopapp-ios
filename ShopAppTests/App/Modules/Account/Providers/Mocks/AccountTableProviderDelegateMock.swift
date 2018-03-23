//
//  AccountTableProviderDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/5/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

@testable import ShopApp

class AccountTableProviderDelegateMock: NSObject, AccountTableProviderDelegate, AccountNotLoggedHeaderDelegate, AccountLoggedHeaderDelegate, AccountFooterDelegate {
    var provider: AccountTableProvider?
    var policy: Policy?
    
    // MARK: - AccountTableProviderDelegate
    
    func provider(_ provider: AccountTableProvider, didSelect policy: Policy) {
        self.provider = provider
        self.policy = policy
    }
    
    // MARK: - AccountNotLoggedHeaderDelegate
    
    func headerViewDidTapSignIn(_ headerView: AccountNotLoggedHeaderView) {}
    func headerViewDidTapCreateNewAccount(_ headerView: AccountNotLoggedHeaderView) {}
    
    // MARK: - AccountLoggedHeaderDelegate
    
    func headerViewDidTapMyOrders(_ headerView: AccountLoggedHeaderView) {}
    func headerViewDidTapPersonalInfo(_ headerView: AccountLoggedHeaderView) {}
    func headerViewDidTapShippingAddress(_ headerView: AccountLoggedHeaderView) {}
    
    // MARK: - AccountFooterDelegate
    
    func footerViewDidTapLogout(_ footerView: AccountFooterView) {}
}
