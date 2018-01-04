//
//  RepositoryInterface.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/23/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

protocol RepositoryInterface: ShopRepositoryInterface, ProductRepositoryInterface, CategoryRepositoryInterface, ArticleRepositoryInterface, CartRepositoryInterface, AuthentificationRepositoryInterface, PaymentsRepositoryInterface, OrderRepositoryInterface {}
