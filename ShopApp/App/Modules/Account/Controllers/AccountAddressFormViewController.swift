//
//  AccountAddressFormViewController.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 1/31/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

protocol AccountAddressFormControllerDelegate: class {
    func viewController(_ controller: AccountAddressFormViewController, didUpdate address: Address, isSelectedAddress: Bool)
    func viewController(_ controller: AccountAddressFormViewController, didAdd address: Address)
}

class AccountAddressFormViewController: BaseAddressFormViewController<AccountAddressFormViewModel>, AddressFormControllerlDelegate {
    var isSelectedAddress = false
    
    weak var delegate: AccountAddressFormControllerDelegate?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
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
        viewModel.filledAddress
            .subscribe(onNext: { [weak self] address in
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.addressAction == .add {
                    strongSelf.delegate?.viewController(strongSelf, didAdd: address)
                } else {
                    strongSelf.delegate?.viewController(strongSelf, didUpdate: address, isSelectedAddress: strongSelf.isSelectedAddress)
                }
            })
        .disposed(by: disposeBag)
    }
    
    // MARK: - AddressFormControllerlDelegate
    
    func viewController(_ controller: AddressFormViewController, didFill address: Address) {
        if addressAction == .add {
            viewModel.addCustomerAddress(with: address)
        } else {
            viewModel.updateCustomerAddress(with: address)
        }
    }
}
