//
//  ShopObject.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/23/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

class Shop: NSObject {
    var name = ""
    var shopDescription: String?
    var privacyPolicy: Policy?
    var refundPolicy: Policy?
    var termsOfService: Policy?
}
