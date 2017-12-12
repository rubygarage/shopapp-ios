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
    
    func isLoggedIn() -> Bool {
        return APICore?.isLoggedIn() ?? false
    }
    
    func getCustomer(callback: @escaping RepoCallback<Customer>) {
        APICore?.getCustomer(callback: callback)
    }
}
