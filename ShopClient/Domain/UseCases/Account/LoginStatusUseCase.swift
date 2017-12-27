//
//  LoginStatusUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct LoginStatusUseCase {
    public func getLoginStatus(_ callback: (_ isLoggedIn: Bool) -> Void) {
        let isLoggedIn = Repository.shared.isLoggedIn()
        callback(isLoggedIn)
    }
}
