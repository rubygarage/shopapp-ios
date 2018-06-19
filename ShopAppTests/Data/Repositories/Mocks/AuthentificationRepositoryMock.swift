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
    
    func signUp(firstName: String, lastName: String, email: String, password: String, phone: String, callback: @escaping RepoCallback<Void>) {
        isSignUpStarted = true
        
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.phone = phone
        
        callback((), isNeedToReturnError ? RepoError() : nil)
    }
    
    func signIn(email: String, password: String, callback: @escaping RepoCallback<Void>) {
        isLoginStarted = true
        
        self.email = email
        self.password = password
        
        callback((), isNeedToReturnError ? RepoError() : nil)
    }
    
    func signOut(callback: @escaping RepoCallback<Void>) {
        isLogoutStarted = true
        
        callback((), isNeedToReturnError ? RepoError() : nil)
    }
    
    func isSignedIn(callback: @escaping RepoCallback<Bool>) {
        isGetLoginStatusStarted = true
        
        return isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
    
    func resetPassword(email: String, callback: @escaping RepoCallback<Void>) {
        isResetPasswordStarted = true
        
        self.email = email
        
        callback((), isNeedToReturnError ? RepoError() : nil)
    }
}
