//
//  CheckoutAddressListViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift

class CheckoutAddressListViewController: BaseAddressListViewController<CheckoutAddressListViewModel> {
    var checkoutId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
    }
    
    private func setupViewModel() {
        viewModel.checkoutId = checkoutId
        
        viewModel.didSelectBillingAddress
            .subscribe(onNext: { [weak self] address in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.selectedAddress = address
                strongSelf.viewModel.selectedAddress = address
                strongSelf.delegate?.viewController(didSelectBillingAddress: address)
            })
            .disposed(by: disposeBag)
    }
}
