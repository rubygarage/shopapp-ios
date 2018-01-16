//
//  PaymentTypeViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class PaymentTypeViewModel: BaseViewModel {
    var selectedType: PaymentTypeSection?
    var checkout: Checkout!
    
    private let checkoutUseCase = CheckoutUseCase()
    
    public func setupApplePay() {
        checkoutUseCase.setupApplePay(with: checkout) { (success, error) in
            // TODO:
        }
    }
}
