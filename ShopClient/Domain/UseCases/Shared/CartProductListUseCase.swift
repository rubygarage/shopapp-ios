//
//  CartProductListUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct CartProductListUseCase {
    public func getCartProductList(_ callback: @escaping (_ products: [CartProduct]) -> Void) {
        Repository.shared.getCartProductList { (products, _) in
            if let products = products {
                callback(products)
            }
        }
    }
}
