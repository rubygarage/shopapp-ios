//
//  LoginUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

typealias LoginStatusCallback = (_ isLoggedIn: Bool) -> Void

struct LoginUseCase {
    public func login(with email: String, password: String, _ callback: @escaping RepoCallback<Bool>) {
        Repository.shared.login(with: email, password: password, callback: callback)
    }
    
    public func getLoginStatus(_ callback: LoginStatusCallback) {
        let isLoggedIn = Repository.shared.isLoggedIn()
        callback(isLoggedIn)
    }
}
