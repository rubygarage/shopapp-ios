//
//  SessionService.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/18/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import KeychainAccess

struct SessionService {
    private let serviceName = "SessionDataIdentifier"
    private let tokenKey = "AccessToken"
    private let emailKey = "Email"
    private let passwordKey = "Password"
    private let loggedInStatusKey = "LoggedInStatus"
    
    var data: (token: String?, email: String?, password: String?) {
        let keychain = Keychain(service: serviceName)
        let token = keychain[tokenKey]
        let email = keychain[emailKey]
        let password = keychain[passwordKey]

        return (token, email, password)
    }
    
    var isSignedIn: Bool {
        guard UserDefaults.standard.value(forKey: loggedInStatusKey) as? Bool != nil else {
            removeData()

            return false
        }
        
        let keychain = Keychain(service: serviceName)
        
        guard keychain[tokenKey] != nil, keychain[emailKey] != nil, keychain[passwordKey] != nil else {
            removeData()
            
            return false
        }
        
        return true
    }
    
    func save(token: String, email: String, password: String) {
        let keychain = Keychain(service: serviceName)
        keychain[tokenKey] = token
        keychain[emailKey] = email
        keychain[passwordKey] = password
        
        UserDefaults.standard.set(true, forKey: loggedInStatusKey)
    }
    
    func update(email: String) {
        let keychain = Keychain(service: serviceName)
        keychain[emailKey] = email
    }
    
    func update(password: String) {
        let keychain = Keychain(service: serviceName)
        keychain[passwordKey] = password
    }
    
    func removeData() {
        let keychain = Keychain(service: serviceName)
        try? keychain.removeAll()
        
        UserDefaults.standard.set(false, forKey: loggedInStatusKey)
    }
}
