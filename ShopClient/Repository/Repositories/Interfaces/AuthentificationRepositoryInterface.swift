//
//  AuthentificationRepositoryInterface.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/10/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

protocol AuthentificationRepositoryInterface {
    func signUp(with email: String, firstName: String?, lastName: String?, password: String, phone: String?, callback: @escaping RepoCallback<Bool>)
    func isLoggedIn() -> Bool
}
