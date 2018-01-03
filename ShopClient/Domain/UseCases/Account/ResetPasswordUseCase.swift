//
//  ResetPasswordUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct ResetPasswordUseCase {
    public func resetPassword(with email: String, _ callback: @escaping RepoCallback<Bool>) {
        Repository.shared.resetPassword(with: email, callback: callback)
    }
}
