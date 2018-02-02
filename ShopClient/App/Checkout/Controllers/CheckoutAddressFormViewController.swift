//
//  CheckoutAddressFormViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/30/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class CheckoutAddressFormViewController: BaseViewController<CheckoutAddressFormViewModel> {    
    var checkoutId: String!
    var addressType: AddressListType = .shipping
    var address: Address?
    
    weak var delegate: CheckoutAddressFormModelDelegate?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = CheckoutAddressFormViewModel()
        super.viewDidLoad()

        setupViews()
        setupViewModel()
    }
    
    private func setupViews() {
        title = "ControllerTitle.AddNewAddress".localizable
    }
    
    private func setupViewModel() {
        viewModel.checkoutId = checkoutId
        viewModel.addressType = addressType
        viewModel.delegate = delegate
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addressFormController = segue.destination as? AddressFormViewController {
            addressFormController.address = address
            addressFormController.delegate = self
        }
    }
}

extension CheckoutAddressFormViewController: AddressFormViewModelDelegate {
    func viewModel(_ model: AddressFormViewModel, didFill address: Address) {
        viewModel.updateAddress(with: address)
    }
}
