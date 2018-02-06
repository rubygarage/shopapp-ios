//
//  AuthentificationRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/10/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

extension Repository: AuthentificationRepositoryInterface {
    func signUp(with email: String, firstName: String?, lastName: String?, password: String, phone: String?, callback: @escaping RepoCallback<Bool>) {
        APICore?.signUp(with: email, firstName: firstName, lastName: lastName, password: password, phone: phone, callback: callback)
    }
    
    func login(with email: String, password: String, callback: @escaping RepoCallback<Bool>) {
        APICore?.login(with: email, password: password, callback: callback)
    }
    
    func logout(callback: RepoCallback<Bool>) {
        APICore?.logout(callback: callback)
    }
    
    func isLoggedIn() -> Bool {
        return APICore?.isLoggedIn() ?? false
    }
    
    func resetPassword(with email: String, callback: @escaping RepoCallback<Bool>) {
        APICore?.resetPassword(with: email, callback: callback)
    }
    
    func getCustomer(callback: @escaping RepoCallback<Customer>) {
        APICore?.getCustomer(callback: callback)
    }
    
    func updateCustomer(with email: String, firstName: String?, lastName: String?, phone: String?, callback: @escaping RepoCallback<Customer>) {
        APICore?.updateCustomer(with: email, firstName: firstName, lastName: lastName, phone: phone, callback: callback)
    }
    
    func updateCustomer(with promo: Bool, callback: @escaping RepoCallback<Customer>) {
        APICore?.updateCustomer(with: promo, callback: callback)
    }
    
    func updateCustomer(with password: String, callback: @escaping RepoCallback<Customer>) {
        APICore?.updateCustomer(with: password, callback: callback)
    }
}
