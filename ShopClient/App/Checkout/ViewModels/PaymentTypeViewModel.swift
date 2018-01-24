//
//  PaymentTypeViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class PaymentTypeViewModel: BaseViewModel {
    private let checkoutUseCase = CheckoutUseCase()
    
    var selectedType: PaymentTypeSection?
    var checkout: Checkout!
    
    public func setupApplePay() {
        checkoutUseCase.setupApplePay(with: checkout) { [weak self] (success, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let success = success, success == true {
                // TODO:
            }
        }
    }
}
