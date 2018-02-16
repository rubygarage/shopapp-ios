//
//  ResetPasswordUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import ShopClient_Gateway

class ResetPasswordUseCase {
    private lazy var repository = AppDelegate.getRepository()

    func resetPassword(with email: String, _ callback: @escaping RepoCallback<Bool>) {
        repository.resetPassword(with: email, callback: callback)
    }
}
