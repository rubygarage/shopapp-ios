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
    private let customerUseCase = CustomerUseCase()
    
    var customerAddresses = Variable<[Address]>([])
    var customerDefaultAddress = Variable<Address?>(nil)
    var didSelectAddress = PublishSubject<Address>()
    var selectedAddress: Address?
    var completion: AddressListCompletion?
    
    func loadCustomerAddresses() {
        state.onNext(.loading(showHud: true))
        Repository.shared.getCustomer { [weak self] (customer, _) in
            guard let strongSelf = self else {
                return
            }
            if let addresses = customer?.addresses {
                strongSelf.customerAddresses.value = addresses
                strongSelf.customerDefaultAddress.value = customer?.defaultAddress
            }
            strongSelf.state.onNext(.content)
        }
    }
    
    func item(at index: Int) -> AddressTuple {
        if index < customerAddresses.value.count {
            let address = customerAddresses.value[index]
            let selected = selectedAddress?.isEqual(to: address) ?? false
            let isDefault = customerDefaultAddress.value?.isEqual(to: address) ?? false
            return (address, selected, isDefault)
        }
        return (Address(), false, false)
    }
    
    func updateCheckoutShippingAddress(with address: Address) {
        selectedAddress = address
        loadCustomerAddresses()
        completion?(address)
        didSelectAddress.onNext(address)
    }
    
    func updateAddress(with address: Address, isSelected: Bool) {
        state.onNext(.loading(showHud: true))
        Repository.shared.updateCustomerAddress(with: address) { [weak self] (success, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let success = success {
                strongSelf.processAddressUpdatingResponse(with: success, address: address, isSelected: isSelected)
                strongSelf.state.onNext(.content)
            }
        }
    }
    
    func deleteCustomerAddress(with address: Address) {
        state.onNext(.loading(showHud: true))
        Repository.shared.deleteCustomerAddress(with: address.id) { [weak self] (success, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let success = success {
                strongSelf.processDeleteAddressResponse(with: success)
                strongSelf.state.onNext(.content)
            }
        }
    }
    
    func addCustomerAddress(with address: Address) {
        state.onNext(.loading(showHud: true))
        Repository.shared.addCustomerAddress(with: address) { [weak self] (_, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else {
                strongSelf.loadCustomerAddresses()
            }
        }
    }
    
    func updateCustomerDefaultAddress(with address: Address) {
        state.onNext(.loading(showHud: true))
        customerUseCase.updateDefaultAddress(with: address.id) { [weak self] (customer, error) in
            guard let strongSelf = self else {
                return
            }
            if let addresses = customer?.addresses, let defaultAddress = customer?.defaultAddress {
                strongSelf.customerAddresses.value = addresses
                strongSelf.customerDefaultAddress.value = defaultAddress
                strongSelf.state.onNext(.content)
            } else {
                strongSelf.state.onNext(.error(error: error))
            }
        }
    }
    
    private func processAddressUpdatingResponse(with success: Bool, address: Address, isSelected: Bool) {
        if success {
            processSelectedAddressUpdatingResponse(with: address, isSelected: isSelected)
            loadCustomerAddresses()
        }
    }
    
    private func processDeleteAddressResponse(with success: Bool) {
        if success {
            loadCustomerAddresses()
        }
    }
    
    private func processSelectedAddressUpdatingResponse(with address: Address, isSelected: Bool) {
        if isSelected {
            selectedAddress = address
        }
    }
}

internal extension Address {
    func isEqual(to object: Address) -> Bool {
        return fullName == object.fullName && fullAddress == object.fullAddress && phone == object.phone
    }
}
