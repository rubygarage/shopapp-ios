//
//  AddressListViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

typealias AddressListCompletion = (_ address: Address) -> Void

class AddressListViewModel: BaseViewModel {
    var customerAddresses = Variable<[Address]>([Address]())
    var didSelectAddress = PublishSubject<Address>()
    
    var selectedAddress: Address?
    var completion: AddressListCompletion?
    
    // MARK: - public
    public func loadCustomerAddresses() {
        state.onNext(.loading(showHud: true))
        Repository.shared.getCustomer { [weak self] (customer, _) in
            if let addresses = customer?.addresses {
                self?.customerAddresses.value = addresses
            }
            self?.state.onNext(.content)
        }
    }
    
    public func item(at index: Int) -> AddressTuple {
        if index < customerAddresses.value.count {
            let address = customerAddresses.value[index]
            let selected = selectedAddress?.isEqual(to: address) ?? false
            return (address, selected)
        }
        return (Address(), false)
    }
    
    public func updateCheckoutShippingAddress(with address: Address) {
        selectedAddress = address
        loadCustomerAddresses()
        completion?(address)
        didSelectAddress.onNext(address)
    }
    
    public func updateAddress(with address: Address, isSelected: Bool) {
        state.onNext(.loading(showHud: true))
        Repository.shared.updateCustomerAddress(with: address) { [weak self] (success, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            } else if let success = success {
                self?.processAddressUpdatingResponse(with: success, address: address, isSelected: isSelected)
                self?.state.onNext(.content)
            }
        }
    }
    
    public func deleteCustomerAddress(with address: Address) {
        state.onNext(.loading(showHud: true))
        Repository.shared.deleteCustomerAddress(with: address.id) { [weak self] (success, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            } else if let success = success {
                success ? self?.loadCustomerAddresses() : ()
                self?.state.onNext(.content)
            }
        }
    }
    
    public func addCustomerAddress(with address: Address, isDefaultAddress: Bool) {
        state.onNext(.loading(showHud: true))
        Repository.shared.addCustomerAddress(with: address) { [weak self] (addressId, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            } else if let addressId = addressId {
                self?.processAddressAddingResponse(with: addressId, isDefaultAddress: isDefaultAddress)
                self?.state.onNext(.content)
            }
        }
    }
    
    // MARK: - private
    private func processAddressUpdatingResponse(with success: Bool, address: Address, isSelected: Bool) {
        if success {
            processSelectedAddressUpdatingResponse(with: address, isSelected: isSelected)
            loadCustomerAddresses()
        }
    }
    
    private func processSelectedAddressUpdatingResponse(with address: Address, isSelected: Bool) {
        if isSelected {
            selectedAddress = address
            completion?(address)
        }
    }
    
    private func processAddressAddingResponse(with addressId: String, isDefaultAddress: Bool) {
        if isDefaultAddress {
            updateCustomerDefaultAddress(with: addressId)
        } else {
            loadCustomerAddresses()
        }
    }
    
    private func updateCustomerDefaultAddress(with addressId: String) {
        Repository.shared.updateCustomerDefaultAddress(with: addressId) { [weak self] (_, _) in
            self?.loadCustomerAddresses()
        }
    }
}

internal extension Address {
    func isEqual(to object: Address) -> Bool {
        return fullName == object.fullName && fullAddress == object.fullAddress && phone == object.phone
    }
}
