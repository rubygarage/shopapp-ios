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
    func signUp(with email: String, firstName: String?, lastName: String?, password: String, phone: String?, callback: @escaping RepoCallback<Bool>) {}
    
    func login(with email: String, password: String, callback: @escaping RepoCallback<Bool>) {}
    
    func logout(callback: RepoCallback<Bool>) {}
    
    func isLoggedIn() -> Bool {
        return false
    }
    
    func resetPassword(with email: String, callback: @escaping RepoCallback<Bool>) {}
    
    func getCustomer(callback: @escaping RepoCallback<Customer>) {}
    
    func updateCustomer(with email: String, firstName: String?, lastName: String?, phone: String?, callback: @escaping RepoCallback<Customer>) {}
    
    func updateCustomer(with promo: Bool, callback: @escaping RepoCallback<Customer>) {}
    
    func updateCustomer(with password: String, callback: @escaping RepoCallback<Customer>) {}
}
