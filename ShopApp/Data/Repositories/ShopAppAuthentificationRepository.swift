//
//  ShopAppAuthentificationRepository.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/10/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class ShopAppAuthentificationRepository: AuthentificationRepository {
    private let api: API
    
    init(api: API) {
        self.api = api
    }
    
    func signUp(with email: String, firstName: String?, lastName: String?, password: String, phone: String?, callback: @escaping RepoCallback<Bool>) {
        api.signUp(with: email, firstName: firstName, lastName: lastName, password: password, phone: phone, callback: callback)
    }
    
    func login(with email: String, password: String, callback: @escaping RepoCallback<Bool>) {
        api.login(with: email, password: password, callback: callback)
    }
    
    func logout(callback: RepoCallback<Bool>) {
        api.logout(callback: callback)
    }
    
    func isLoggedIn() -> Bool {
        return api.isLoggedIn() 
    }
    
    func resetPassword(with email: String, callback: @escaping RepoCallback<Bool>) {
        api.resetPassword(with: email, callback: callback)
    }
}
