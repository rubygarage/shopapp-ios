//
//  RepoError.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

class RepoError: Error {
    var errorMessage = NSLocalizedString("Error.Unknown", comment: String())
    var statusCode: Int = 0

    init() {}
    
    init?(with error: Error?) {
        if let error = error {
            errorMessage = error.localizedDescription
        } else {
            return nil
        }
    }
}

class CriticalError: RepoError {}
class NonCriticalError: RepoError {}
class ContentError: RepoError {}
