//
//  CartViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class CartViewModel: BaseViewModel {
    var data = Variable<[CartProduct]>([CartProduct]())
    
    public func loadData() {
        state.onNext((state: .loading, error: nil))
        Repository.shared.getCartProductList { [weak self] (result, error) in
            if let error = error {
                self?.state.onNext((state: .error, error: error))
            }
            if let products = result {
                self?.data.value = products
                self?.state.onNext((state: .content, error: nil))
            }
        }
    }
}
