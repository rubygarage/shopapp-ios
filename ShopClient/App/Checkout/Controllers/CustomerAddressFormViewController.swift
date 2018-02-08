//
//  CustomerAddressFormViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/31/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

enum AddressAction {
    case add
    case edit
}

protocol CustomerAddressFormControllerDelegate: class {
    func viewController(_ controller: CustomerAddressFormViewController, didUpdate address: Address)
}

class CustomerAddressFormViewController: BaseViewController<CustomerAddressFormViewModel> {
    var selectedAddress: Address?
    var addressAction: AddressAction = .add
    
    weak var delegate: CustomerAddressFormControllerDelegate?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = CustomerAddressFormViewModel()
        super.viewDidLoad()

        setupViews()
        setupViewModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addressFormController = segue.destination as? AddressFormViewController {
            addressFormController.address = selectedAddress
            addressFormController.delegate = self
        }
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        title = addressAction == .add ? "ControllerTitle.AddNewAddress".localizable : "ControllerTitle.EditAddress".localizable
    }
    
    private func setupViewModel() {
        viewModel.filledAddress
            .subscribe(onNext: { [weak self] address in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.delegate?.viewController(strongSelf, didUpdate: address)
            })
        .disposed(by: disposeBag)
    }
}

extension CustomerAddressFormViewController: AddressFormControllerlDelegate {
    func viewController(_ controller: AddressFormViewController, didFill address: Address) {
        if addressAction == .add {
            viewModel.addCustomerAddress(with: address)
        } else {
            viewModel.updateCustomerAddress(with: address)
        }
    }
}
