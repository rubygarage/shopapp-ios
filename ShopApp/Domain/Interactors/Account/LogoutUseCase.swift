//
//  LogoutUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class LogoutUseCase {
    private let repository: AuthentificationRepository

    init(repository: AuthentificationRepository) {
        self.repository = repository
    }

    func signOut(_ callback: @escaping (_ isLoggedOut: Bool) -> Void) {
        repository.signOut { (success, _) in
            callback(success == true)
        }
    }
}
