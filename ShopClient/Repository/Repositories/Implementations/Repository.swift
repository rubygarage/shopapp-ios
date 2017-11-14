//
//  Repository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

typealias RepoCallback<T> = (_ result: T?, _ error: RepoError?) -> ()

class Repository: NSObject, RepositoryInterface {
    static let shared = Repository()
    var APICore: APIInterface?
    var DAOCore: DAOInterface?
    
    private override init() {
        super.init()
        
        APICore = API()
        DAOCore = DAO()
    }
}
