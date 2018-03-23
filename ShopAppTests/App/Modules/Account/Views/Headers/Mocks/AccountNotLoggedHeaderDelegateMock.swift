//
//  AccountNotLoggedHeaderDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/6/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

@testable import ShopApp

class AccountNotLoggedHeaderDelegateMock: AccountNotLoggedHeaderDelegate {
    var isSignInTapped = false
    var isCreateNewAccountTapped = false
    var headerView: AccountNotLoggedHeaderView?
    
    // MARK: - AccountNotLoggedHeaderDelegate
    
    func headerViewDidTapSignIn(_ headerView: AccountNotLoggedHeaderView) {
        isSignInTapped = true
        self.headerView = headerView
    }
    
    func headerViewDidTapCreateNewAccount(_ headerView: AccountNotLoggedHeaderView) {
        isCreateNewAccountTapped = true
        self.headerView = headerView
    }
}
