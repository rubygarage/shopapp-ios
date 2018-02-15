//
//  Repository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopClient_Gateway

public class ShopifyRepository: Repository {
    
    public static let shared = ShopifyRepository()

    let api: APIInterface

    private init() {
        self.api = API()
    }
}
