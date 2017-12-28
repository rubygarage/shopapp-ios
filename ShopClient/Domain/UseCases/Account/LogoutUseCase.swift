//
//  LogoutUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct LogoutUseCase {
    public func logout(_ callback: @escaping (_ isLoggedOut: Bool) -> Void) {
        Repository.shared.logout { (success, _) in
            callback(success == true)
        }
    }
}
