//
//  ResetPasswordRequest.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct ResetPasswordRequest: Request {
    let email: String
    let template = "email_reset"
    
    init(email: String) {
        self.email = email
    }
}
