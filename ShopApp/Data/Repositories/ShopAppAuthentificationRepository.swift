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
    
    func signUp(firstName: String, lastName: String, email: String, password: String, phone: String, callback: @escaping ApiCallback<Void>) {
        api.signUp(firstName: firstName, lastName: lastName, email: email, password: password, phone: phone, callback: callback)
    }
    
    func signIn(email: String, password: String, callback: @escaping ApiCallback<Void>) {
        api.signIn(email: email, password: password, callback: callback)
    }
    
    func signOut(callback: @escaping ApiCallback<Void>) {
        api.signOut(callback: callback)
    }
    
    func isSignedIn(callback: @escaping ApiCallback<Bool>) {
        api.isSignedIn(callback: callback)
    }
    
    func resetPassword(email: String, callback: @escaping ApiCallback<Void>) {
        api.resetPassword(email: email, callback: callback)
    }
}
