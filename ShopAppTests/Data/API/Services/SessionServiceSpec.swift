//
//  SessionServiceSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/17/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import KeychainAccess
import Nimble
import Quick

@testable import ShopApp

class SessionServiceSpec: QuickSpec {
    override func spec() {
        let serviceName = "SessionDataIdentifier"
        let tokenKey = "AccessToken"
        let emailKey = "Email"
        let passwordKey = "Password"
        let loggedInStatusKey = "LoggedInStatus"
        let token = "token"
        let email = "user@mail.com"
        let updatedEmail = "customer@mail.com"
        let password = "password"
        let updatedPassword = "PASSWORD"
        
        var service: SessionService!
        var keychain: Keychain!
        
        beforeEach {
            service = SessionService()
            keychain = Keychain(service: serviceName)
        }
        
        describe("when session data got") {
            it("needs to return") {
                service.save(token: token, email: email, password: password)
                
                let data = service.data
                
                expect(data.token) == token
                expect(data.email) == email
                expect(data.password) == password
            }
        }
        
        describe("when logged in status got") {
            context("if user defaults hasn't logged in value") {
                it("needs to return false") {
                    UserDefaults.standard.set(nil, forKey: loggedInStatusKey)
                    
                    expect(service.isLoggedIn) == false
                }
            }
            
            context("if keychain hasn't some data") {
                it("needs to return false") {
                    service.save(token: token, email: email, password: password)
                    keychain[tokenKey] = nil
                    
                    expect(service.isLoggedIn) == false
                }
            }
            
            context("if all data in keychain and user defaults are valid") {
                it("needs to return true") {
                    service.save(token: token, email: email, password: password)
                    
                    expect(service.isLoggedIn) == true
                }
            }
        }

        describe("when session data added") {
            it("needs to add data to keychain") {
                service.save(token: token, email: email, password: password)
                
                expect(keychain[tokenKey]) == token
                expect(keychain[emailKey]) == email
                expect(keychain[passwordKey]) == password
                expect(UserDefaults.standard.bool(forKey: loggedInStatusKey)) == true
            }
        }
        
        describe("when session data updated with email") {
            it("needs to update email data in keychain") {
                service.update(email: updatedEmail)
                
                expect(keychain[emailKey]) == updatedEmail
            }
        }
        
        describe("when session data updated with password") {
            it("needs to update password data in keychain") {
                service.update(password: updatedPassword)

                expect(keychain[passwordKey]) == updatedPassword
            }
        }
        
        describe("when session data removed") {
            it("needs to remove data from keychain") {
                service.removeData()
                
                expect(keychain[tokenKey]).to(beNil())
                expect(keychain[emailKey]).to(beNil())
                expect(keychain[passwordKey]).to(beNil())
            }
        }
    }
}
