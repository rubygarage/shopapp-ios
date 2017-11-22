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
    
    init(with mesage: String) {
        errorMessage = mesage
    }
}

class CriticalError: RepoError {
    init?(with error: Error?, statusCode: Int?) {
        super.init(with: error)
        
        if let code = statusCode {
            self.statusCode = code
        }
    }
    
    init?(with error: Error?, message: String?) {
        super.init(with: error)
        
        if let errorMessage = message {
            self.errorMessage = errorMessage
        }
    }
}
class NonCriticalError: RepoError {}
class ContentError: RepoError {}
class NetworkError: RepoError {
    override init() {
        super.init()
        
        errorMessage = NSLocalizedString("Error.NoConnection", comment: String())
    }
}
