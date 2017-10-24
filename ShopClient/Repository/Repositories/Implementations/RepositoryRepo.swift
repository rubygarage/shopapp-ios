//
//  Repository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

typealias RepoCallback<T> = (_ result: T?, _ error: Error?) -> ()

class RepositoryRepo: NSObject, RepositoryInterface {
    static let shared = RepositoryRepo()
    var APICore: APIInterface?
    var DAOCore: DAOInterface?
    
    private override init() {
        super.init()
        
        APICore = API()
        DAOCore = DAO()
    }
}
