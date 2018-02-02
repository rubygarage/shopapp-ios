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

class CustomerAddressFormViewController: BaseViewController<CustomerAddressFormViewModel> {
    var selectedAddress: Address?
    var addressAction: AddressAction = .add
    
    weak var delegate: CustomerAddressFormModelDelegate?
    
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
        title = "ControllerTitle.AddNewAddress".localizable
    }
    
    private func setupViewModel() {
        viewModel.delegate = delegate
    }
}

extension CustomerAddressFormViewController: AddressFormViewModelDelegate {
    func viewModel(_ model: AddressFormViewModel, didFill address: Address) {
        if addressAction == .add {
            viewModel.addCustomerAddress(with: address)
        } else {
            viewModel.updateCustomerAddress(with: address)
        }
    }
}
