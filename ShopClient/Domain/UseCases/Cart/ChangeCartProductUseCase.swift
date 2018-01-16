//
//  ChangeCartProductUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct ChangeCartProductUseCase {
    public func changeCartProductQuantity(productVariantId: String?, quantity: Int, _ callback: @escaping RepoCallback<CartProduct>) {
        Repository.shared.changeCartProductQuantity(with: productVariantId, quantity: quantity, callback: callback)
    }
}
