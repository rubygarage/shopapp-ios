//
//  LoginUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 12/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

typealias LoginStatusCallback = (_ isLoggedIn: Bool) -> Void

class LoginUseCase {
    private let repository: AuthentificationRepository

    init(repository: AuthentificationRepository) {
        self.repository = repository
    }

    func login(with email: String, password: String, _ callback: @escaping RepoCallback<Bool>) {
        repository.login(with: email, password: password, callback: callback)
    }
    
    func getLoginStatus(_ callback: LoginStatusCallback) {
        let isLoggedIn = repository.isLoggedIn()
        callback(isLoggedIn)
    }
}
