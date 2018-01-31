//
//  CheckoutAddressFormViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/30/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class CheckoutAddressFormViewController: BaseViewController<CheckoutAddressFormViewModel> {
    
    var address: Address?
    var completion: AddressFormCompletion?
    
    override func viewDidLoad() {
        viewModel = CheckoutAddressFormViewModel()
        super.viewDidLoad()

        setupViews()
    }
    
    private func setupViews() {
        title = "ControllerTitle.AddNewAddress".localizable
        
        if let addressFormController = childViewControllers.first as? AddressFormViewController {
            print("adddddd")
            addressFormController.address = address
        }
//        let addressFormViewController = UIStoryboard(name: "Checkout", bundle: nil).instantiateViewController(withIdentifier: "<#T##String#>")
    }
}
