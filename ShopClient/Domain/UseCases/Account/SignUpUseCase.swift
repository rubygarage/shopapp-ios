//
//  SignUpUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct SignUpUseCase {
    public func signUp(with email: String, firstName: String?, lastName: String?, password: String, phone: String?, _ callback: @escaping RepoCallback<Bool>) {
        Repository.shared.signUp(with: email, firstName: firstName, lastName: lastName, password: password, phone: phone, callback: callback)
    }
}
