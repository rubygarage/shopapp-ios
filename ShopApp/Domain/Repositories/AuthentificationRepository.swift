//
//  AuthentificationRepository.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/10/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

protocol AuthentificationRepository {
    func signUp(firstName: String, lastName: String, email: String, password: String, phone: String, callback: @escaping RepoCallback<Bool>)

    func signIn(email: String, password: String, callback: @escaping RepoCallback<Bool>)

    func signOut(callback: @escaping RepoCallback<Bool>)

    func isSignedIn(callback: @escaping RepoCallback<Bool>)

    func resetPassword(email: String, callback: @escaping RepoCallback<Bool>)
}
