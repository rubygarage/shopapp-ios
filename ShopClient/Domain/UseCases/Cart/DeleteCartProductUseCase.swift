//
//  DeleteCartProductUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct DeleteCartProductUseCase {
    func deleteProductFromCart(productVariantId: String?, _ callback: @escaping RepoCallback<Bool>) {
        Repository.shared.deleteProductFromCart(with: productVariantId, callback: callback)
    }
}
