//
//  AccountFooterDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/6/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

@testable import ShopApp

class AccountFooterDelegateMock: AccountFooterDelegate {
    var footerView: AccountFooterView?
    
    // MARK: - AccountFooterDelegate
    
    func footerViewDidTapLogout(_ footerView: AccountFooterView) {
        self.footerView = footerView
    }
}
