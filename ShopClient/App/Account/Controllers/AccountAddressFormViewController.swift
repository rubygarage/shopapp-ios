//
//  AccountAddressFormViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/31/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol AccountAddressFormControllerDelegate: class {
    func viewController(_ controller: AccountAddressFormViewController, didUpdate address: Address)
    func viewController(_ controller: AccountAddressFormViewController, didAdd address: Address)
}

class AccountAddressFormViewController: BaseAddressFormViewController<AccountAddressFormViewModel> {
    weak var delegate: AccountAddressFormControllerDelegate?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = AccountAddressFormViewModel()
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
                    strongSelf.delegate?.viewController(strongSelf, didUpdate: address)
                }
            })
        .disposed(by: disposeBag)
    }
}

extension AccountAddressFormViewController: AddressFormControllerlDelegate {
    func viewController(_ controller: AddressFormViewController, didFill address: Address) {
        if addressAction == .add {
            viewModel.addCustomerAddress(with: address)
        } else {
            viewModel.updateCustomerAddress(with: address)
        }
    }
}
