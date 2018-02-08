//
//  CheckoutAddressFormViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/30/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol CheckoutAddressFormControllerDelegate: class {
    func viewControllerDidUpdateShippingAddress(_ controller: CheckoutAddressFormViewController)
    func viewController(_ controller: CheckoutAddressFormViewController, didFill billingAddress: Address)
}

class CheckoutAddressFormViewController: BaseAddressFormViewController<CheckoutAddressFormViewModel> {
    var checkoutId: String!
    var addressType: AddressListType = .shipping
    
    weak var delegate: CheckoutAddressFormControllerDelegate?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = CheckoutAddressFormViewModel()
        super.viewDidLoad()

        setupViewModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addressFormController = segue.destination as? AddressFormViewController {
            addressFormController.address = selectedAddress
            addressFormController.delegate = self
        }
    }
    
    // MARK: - Setup
    
    private func setupViewModel() {
        viewModel.checkoutId = checkoutId
        viewModel.addressType = addressType
        
        viewModel.updatedShippingAddress
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.delegate?.viewControllerDidUpdateShippingAddress(strongSelf)
            })
            .disposed(by: disposeBag)
        
        viewModel.filledBillingAddress
            .subscribe(onNext: { [weak self] address in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.delegate?.viewController(strongSelf, didFill: address)
            })
            .disposed(by: disposeBag)
    }
}

extension CheckoutAddressFormViewController: AddressFormControllerlDelegate {
    func viewController(_ controller: AddressFormViewController, didFill address: Address) {
        viewModel.updateAddress(with: address)
    }
}
