//
//  ShopDAOInterface.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

protocol ShopDAOInterface {
    func save(shopObject: ShopObject, callback: @escaping () -> ())
}
