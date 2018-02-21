//
//  RepoError.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public class RepoError: Error {
    public private(set) var errorMessage: String?

    public var statusCode: Int = 0

    public init() {}
    
    public init?(with error: Error?) {
        if let error = error {
            if error is RepoError {
                errorMessage = (error as! RepoError).errorMessage ?? error.localizedDescription
            } else {
                errorMessage = error.localizedDescription
            }
        } else {
            return nil
        }
    }
    
    public init(with mesage: String) {
        errorMessage = mesage
    }
}

public class CriticalError: RepoError {
    public init?(with error: Error?, statusCode: Int?) {
        super.init(with: error)
        
        if let code = statusCode {
            self.statusCode = code
        }
    }
    
    public init?(with error: Error?, message: String?) {
        if let errorMessage = message {
            super.init(with: errorMessage)
        } else {
            super.init(with: error)
        }
    }
}
public class NonCriticalError: RepoError {}
public class ContentError: RepoError {}
public class NetworkError: RepoError {}
