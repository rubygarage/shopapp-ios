//
//  AuthentificationRepositoryInterface.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/10/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public protocol AuthentificationRepository {
    func signUp(with email: String, firstName: String?, lastName: String?, password: String, phone: String?, callback: @escaping RepoCallback<Bool>)
    func login(with email: String, password: String, callback: @escaping RepoCallback<Bool>)
    func logout(callback: RepoCallback<Bool>)
    func isLoggedIn() -> Bool
    func resetPassword(with email: String, callback: @escaping RepoCallback<Bool>)
    func getCustomer(callback: @escaping RepoCallback<Customer>)
    func updateCustomer(with email: String, firstName: String?, lastName: String?, phone: String?, callback: @escaping RepoCallback<Customer>)
    func updateCustomer(with promo: Bool, callback: @escaping RepoCallback<Customer>)
    func updateCustomer(with password: String, callback: @escaping RepoCallback<Customer>)
}
