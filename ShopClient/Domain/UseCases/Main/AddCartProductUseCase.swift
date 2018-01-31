//
//  AddCartProductUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct AddCartProductUseCase {
    func addCartProduct(_ cartProduct: CartProduct, _ callback: @escaping RepoCallback<CartProduct>) {
        Repository.shared.addCartProduct(cartProduct: cartProduct, callback: callback)
    }
}
