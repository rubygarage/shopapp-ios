//
//  BaseAddressFormViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/8/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

enum AddressAction {
    case add
    case edit
}

class BaseAddressFormViewController<T: BaseViewModel>: BaseViewController<T> {
    var selectedAddress: Address?
    var addressAction: AddressAction = .add
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        title = addressAction == .add ? "ControllerTitle.AddNewAddress".localizable : "ControllerTitle.EditAddress".localizable
    }
}
