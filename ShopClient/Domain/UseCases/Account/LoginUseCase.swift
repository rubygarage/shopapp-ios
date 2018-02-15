//
//  LoginUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopClient_Gateway

typealias LoginStatusCallback = (_ isLoggedIn: Bool) -> Void

struct LoginUseCase {
    private let repository: Repository!

    init() {
        self.repository = nil
    }

    func login(with email: String, password: String, _ callback: @escaping RepoCallback<Bool>) {
        repository.login(with: email, password: password, callback: callback)
    }
    
    func getLoginStatus(_ callback: LoginStatusCallback) {
        let isLoggedIn = repository.isLoggedIn()
        callback(isLoggedIn)
    }
}
