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
    
    weak var delegate: CustomerAddressFormDelegate?
    
    override func viewDidLoad() {
        viewModel = CustomerAddressFormViewModel()
        super.viewDidLoad()

        setupViews()
        setupViewModel()
    }
    
    private func setupViews() {
        title = "ControllerTitle.AddNewAddress".localizable
    }
    
    private func setupViewModel() {
        viewModel.delegate = delegate
    }
    
    private func addAddressCompletion() -> AddressFormCompletion? {
        return { [weak self] address in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel.addCustomerAddress(with: address)
        }
    }
    
    private func updateAddressCompletion() -> AddressFormCompletion? {
        return { [weak self] address in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel.updateCustomerAddress(with: address)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addressFormController = segue.destination as? AddressFormViewController {
            addressFormController.address = selectedAddress
            addressFormController.completion = addressAction == .add ? addAddressCompletion() : updateAddressCompletion()
        }
    }
}
