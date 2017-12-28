//
//  LoginUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct LoginUseCase {
    public func login(with email: String, password: String, _ callback: @escaping RepoCallback<Bool>) {
        Repository.shared.login(with: email, password: password, callback: callback)
    }
    
    public func getLoginStatus(_ callback: (_ isLoggedIn: Bool) -> Void) {
        let isLoggedIn = Repository.shared.isLoggedIn()
        callback(isLoggedIn)
    }
}
