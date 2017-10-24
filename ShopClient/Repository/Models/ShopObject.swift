//
//  ShopObject.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/23/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ShopObject: NSObject {
    var name = String()
    var shopDescription: String?
    var privacyPolicy: PolicyObject?
    var refundPolicy: PolicyObject?
    var termsOfService: PolicyObject?
}
