//
//  SignInUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 12/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class SignInUseCase {
    private let repository: AuthentificationRepository

    init(repository: AuthentificationRepository) {
        self.repository = repository
    }

    func signIn(email: String, password: String, _ callback: @escaping ApiCallback<Void>) {
        repository.signIn(email: email, password: password, callback: callback)
    }
    
    func isSignedIn(_ callback: @escaping ApiCallback<Bool>) {
        repository.isSignedIn(callback: callback)
    }
}
