//
//  ResetPasswordUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import ShopClient_Gateway

struct ResetPasswordUseCase {
    private let repository: Repository!

    init() {
        self.repository = nil
    }

    func resetPassword(with email: String, _ callback: @escaping RepoCallback<Bool>) {
        repository.resetPassword(with: email, callback: callback)
    }
}
