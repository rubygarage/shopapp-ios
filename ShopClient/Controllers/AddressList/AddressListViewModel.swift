//
//  AddressListViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

protocol AddressListViewModelProtocol {
    func didUpdateShippingAddress()
}

class AddressListViewModel: BaseViewModel {
    var customerAddresses = Variable<[Address]>([Address]())
    
    var checkoutId: String!
    var selectedAddress: Address!
    var delegate: AddressListViewModelProtocol!
    
    // MARK: - public
    public func loadCustomerAddresses() {
        state.onNext(.loading(showHud: true))
        Repository.shared.getCustomer { [weak self] (customer, error) in
            if let addresses = customer?.addresses {
                self?.customerAddresses.value = addresses
                self?.state.onNext(.content)
            } else if let error = error {
                self?.state.onNext(.error(error: error))
            }
        }
    }
    
    public func item(at index: Int) -> AddressTuple {
        if index < customerAddresses.value.count {
            let address = customerAddresses.value[index]
            let selected = address.isEqual(to: selectedAddress)
            return (address, selected)
        }
        return (Address(), false)
    }
    
    public func updateCheckoutShippingAddress(with address: Address) {
        state.onNext(.loading(showHud: true))
        Repository.shared.updateShippingAddress(with: checkoutId, address: address) { [weak self] (success, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            } else if let success = success {
                self?.processUpdatingResponse(with: success, address: address)
                self?.state.onNext(.content)
            }
        }
    }
    
    public func deleteCustomerAddress(with address: Address) {
        Repository.shared.deleteCustomerAddress(with: address.id) { [weak self] (success, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            } else if let success = success {
                success ? self?.loadCustomerAddresses() : ()
                self?.state.onNext(.content)
            }
        }
    }
    
    // MARK: - private
    private func processUpdatingResponse(with success: Bool, address: Address) {
        if success {
            selectedAddress = address
            loadCustomerAddresses()
            delegate.didUpdateShippingAddress()
        }
    }
}

internal extension Address {
    func isEqual(to object: Address) -> Bool {
        return fullname == object.fullname && fullAddress == object.fullAddress && phone == object.phone
    }
}
