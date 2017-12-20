//
//  CheckoutNewViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

enum CheckoutSection: Int {
    case cart
    
    static let allValues = [cart]
}

class CheckoutNewViewModel: BaseViewModel {
    var cartItems = Variable<[CartProduct]>([CartProduct]())
    
    public func loadData() {
        state.onNext(.loading(showHud: true))
        Repository.shared.getCartProductList { [weak self] (result, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let cartItems = result {
                self?.cartItems.value = cartItems
                self?.state.onNext(.content)
            }
        }
    }
}
