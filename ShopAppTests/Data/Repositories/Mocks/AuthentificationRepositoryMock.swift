//
//  AuthentificationRepositoryMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class AuthentificationRepositoryMock: AuthentificationRepository {
    var isNeedToReturnError = false
    var isSignUpStarted = false
    var isLoginStarted = false
    var isLogoutStarted = false
    var isGetLoginStatusStarted = false
    var isResetPasswordStarted = false
    var email: String?
    var firstName: String?
    var lastName: String?
    var password: String?
    var phone: String?
    
    func signUp(with email: String, firstName: String?, lastName: String?, password: String, phone: String?, callback: @escaping RepoCallback<Bool>) {
        isSignUpStarted = true
        
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.phone = phone
        
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
    
    func login(with email: String, password: String, callback: @escaping RepoCallback<Bool>) {
        isLoginStarted = true
        
        self.email = email
        self.password = password
        
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
    
    func logout(callback: RepoCallback<Bool>) {
        isLogoutStarted = true
        
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
    
    func isLoggedIn() -> Bool {
        isGetLoginStatusStarted = true
        
        return !isNeedToReturnError
    }
    
    func resetPassword(with email: String, callback: @escaping RepoCallback<Bool>) {
        isResetPasswordStarted = true
        
        self.email = email
        
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
}
