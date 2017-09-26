//
//  Shop.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class Shop: NSObject {
    var name = String()
    var shopDescription = String()
    var privacyPolicy: Policy?
    var refundPolicy: Policy?
    var termsOfService: Policy?
}
