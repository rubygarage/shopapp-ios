//
//  APIInterface.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/23/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

enum SortingValue: Int {
    case createdAt
    case name
    
    static let allValues = [NSLocalizedString("SortingValue.CreatedAt", comment: String()),
                            NSLocalizedString("SortingValue.Name", comment: String())]
}

protocol APIInterface {
    func getShopInfo(callback: @escaping RepoCallback<ShopObject>)
}
