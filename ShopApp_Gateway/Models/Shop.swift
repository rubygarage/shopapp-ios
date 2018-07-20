//
//  ShopObject.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 10/23/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public struct Shop {
    public let privacyPolicy: Policy?
    public let refundPolicy: Policy?
    public let termsOfService: Policy?

    public init(privacyPolicy: Policy? = nil, refundPolicy: Policy? = nil, termsOfService: Policy?) {
        self.privacyPolicy = privacyPolicy
        self.refundPolicy = refundPolicy
        self.termsOfService = termsOfService
    }
}
