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
    
    func signUp(firstName: String, lastName: String, email: String, password: String, phone: String, callback: @escaping ApiCallback<Void>) {
        isSignUpStarted = true
        
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.phone = phone
        
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
    
    func signIn(email: String, password: String, callback: @escaping ApiCallback<Void>) {
        isLoginStarted = true
        
        self.email = email
        self.password = password
        
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
    
    func signOut(callback: @escaping ApiCallback<Void>) {
        isLogoutStarted = true
        
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
    
    func isSignedIn(callback: @escaping ApiCallback<Bool>) {
        isGetLoginStatusStarted = true
        
        return isNeedToReturnError ? callback(false, ShopAppError.content(isNetworkError: false)) : callback(true, nil)
    }
    
    func resetPassword(email: String, callback: @escaping ApiCallback<Void>) {
        isResetPasswordStarted = true
        
        self.email = email
        
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
}
