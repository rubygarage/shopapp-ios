//
//  CustomerAddressFormViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/31/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class CustomerAddressFormViewController: BaseViewController<CustomerAddressFormViewModel> {
    weak var delegate: CustomerAddressFormDelegate?
    
    override func viewDidLoad() {
        viewModel = CustomerAddressFormViewModel()
        super.viewDidLoad()

        setupViewModel()
    }
    
    private func setupViewModel() {
        viewModel.delegate = delegate
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addressFormController = segue.destination as? AddressFormViewController {
            addressFormController.completion = { [weak self] address in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.viewModel.addCustomerAddress(with: address)
            }
        }
    }
}
