//
//  AuthentificationRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/10/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopClient_Gateway

extension ShopifyRepository: AuthentificationRepository {
    public func signUp(with email: String, firstName: String?, lastName: String?, password: String, phone: String?, callback: @escaping RepoCallback<Bool>) {
        api.signUp(with: email, firstName: firstName, lastName: lastName, password: password, phone: phone, callback: callback)
    }
    
    public func login(with email: String, password: String, callback: @escaping RepoCallback<Bool>) {
        api.login(with: email, password: password, callback: callback)
    }
    
    public func logout(callback: RepoCallback<Bool>) {
        api.logout(callback: callback)
    }
    
    public func isLoggedIn() -> Bool {
        return api.isLoggedIn() 
    }
    
    public func resetPassword(with email: String, callback: @escaping RepoCallback<Bool>) {
        api.resetPassword(with: email, callback: callback)
    }
    
    public func getCustomer(callback: @escaping RepoCallback<Customer>) {
        api.getCustomer(callback: callback)
    }
    
    public func updateCustomer(with email: String, firstName: String?, lastName: String?, phone: String?, callback: @escaping RepoCallback<Customer>) {
        api.updateCustomer(with: email, firstName: firstName, lastName: lastName, phone: phone, callback: callback)
    }
    
    public func updateCustomer(with promo: Bool, callback: @escaping RepoCallback<Customer>) {
        api.updateCustomer(with: promo, callback: callback)
    }
    
    public func updateCustomer(with password: String, callback: @escaping RepoCallback<Customer>) {
        api.updateCustomer(with: password, callback: callback)
    }
}
