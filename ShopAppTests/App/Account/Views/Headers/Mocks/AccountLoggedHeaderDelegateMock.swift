//
//  AccountLoggedHeaderDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/6/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

@testable import ShopApp

class AccountLoggedHeaderDelegateMock: AccountLoggedHeaderDelegate {
    var isMyOrdersTapped = false
    var isPersonalInfoTapped = false
    var isShippingAddressTapped = false
    var headerView: AccountLoggedHeaderView?
    
    // MARK: - AccountLoggedHeaderDelegate
    
    func headerViewDidTapMyOrders(_ headerView: AccountLoggedHeaderView) {
        isMyOrdersTapped = true
        self.headerView = headerView
    }
    
    func headerViewDidTapPersonalInfo(_ headerView: AccountLoggedHeaderView) {
        isPersonalInfoTapped = true
        self.headerView = headerView
    }
    
    func headerViewDidTapShippingAddress(_ headerView: AccountLoggedHeaderView) {
        isShippingAddressTapped = true
        self.headerView = headerView
    }
    
}
