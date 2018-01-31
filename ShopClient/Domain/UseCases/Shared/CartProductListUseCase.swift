//
//  CartProductListUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct CartProductListUseCase {
    func getCartProductList(_ callback: @escaping RepoCallback<[CartProduct]>) {
        Repository.shared.getCartProductList(callback: callback)
    }
}
