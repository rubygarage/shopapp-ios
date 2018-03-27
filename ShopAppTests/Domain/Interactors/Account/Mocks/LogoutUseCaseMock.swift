//
//  LogoutUseCaseMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/5/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class LogoutUseCaseMock: LogoutUseCase {
    var isNeedToReturnError = false
    
    override func logout(_ callback: @escaping (_ isLoggedOut: Bool) -> Void) {
        execute(callback: callback)
    }
    
    private func execute(callback: @escaping (_ isLoggedOut: Bool) -> Void) {
        callback(!isNeedToReturnError)
    }
}
