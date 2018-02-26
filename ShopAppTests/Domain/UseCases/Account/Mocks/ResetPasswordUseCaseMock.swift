//
//  ResetPasswordUseCaseMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class ResetPasswordUseCaseMock: ResetPasswordUseCase {
    private let error = ContentError()
    
    var isNeedToReturnError = false
    
    override func resetPassword(with email: String, _ callback: @escaping RepoCallback<Bool>) {
        execute(callback: callback)
    }
    
    private func execute(callback: @escaping RepoCallback<Bool>) {
        isNeedToReturnError ? callback(nil, error) : callback(true, nil)
    }
}
