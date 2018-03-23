//
//  ResetPasswordUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class ResetPasswordUseCase {
    private let repository: AuthentificationRepository

    init(repository: AuthentificationRepository) {
        self.repository = repository
    }

    func resetPassword(with email: String, _ callback: @escaping RepoCallback<Bool>) {
        repository.resetPassword(with: email, callback: callback)
    }
}
