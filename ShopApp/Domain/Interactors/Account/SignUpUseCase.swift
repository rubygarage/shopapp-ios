//
//  SignUpUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 12/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class SignUpUseCase {
    private let repository: AuthentificationRepository

    init(repository: AuthentificationRepository) {
        self.repository = repository
    }

    func signUp(firstName: String, lastName: String, email: String, password: String, phone: String, _ callback: @escaping ApiCallback<Void>) {
        repository.signUp(firstName: firstName, lastName: lastName, email: email, password: password, phone: phone, callback: callback)
    }
}
