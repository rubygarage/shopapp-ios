//
//  DeleteCartProductsUseCase.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/24/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct DeleteCartProductsUseCase {
    public func clearCart(_ callback: @escaping RepoCallback<Bool>) {
        Repository.shared.deleteAllProductsFromCart(with: callback)
    }
}
