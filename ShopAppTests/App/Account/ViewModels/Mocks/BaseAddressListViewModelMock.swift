//
//  BaseAddressListViewModelMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class BaseAddressListViewModelMock: BaseAddressListViewModel {
    var isNeedsToReturnAddresses = false
    var isLoadCustomerAddressesStarted = false
    var isDeleteCustomerAddressStarted = false
    var isUpdateCustomerDefaultAddressStarted = false
    
    override func loadCustomerAddresses(isTranslucentHud: Bool = false, continueLoading: Bool = false) {
        if isNeedsToReturnAddresses {
            let address = Address()
            address.firstName = "first name"
            address.lastName = "last name"
            address.address = "address"
            address.secondAddress = "second address"
            address.city = "city"
            address.country = "country"
            address.state = "state"
            address.zip = "zip"
            address.phone = "phone"
            customerAddresses.value = [address]
        } else {
            customerAddresses.value = []
        }
        isLoadCustomerAddressesStarted = true
    }
    
    override func deleteCustomerAddress(with address: Address, type: AddressListType) {
        isDeleteCustomerAddressStarted = true
    }
    
    override func updateCustomerDefaultAddress(with address: Address) {
        isUpdateCustomerDefaultAddressStarted = true
    }
    
    func makeSelectedAddress(address: Address) {
        didSelectAddress.onNext(address)
    }
}
