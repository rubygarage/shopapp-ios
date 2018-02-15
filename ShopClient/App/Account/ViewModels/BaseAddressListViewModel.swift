//
//  BaseAddressListViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class BaseAddressListViewModel: BaseViewModel {
    private let customerUseCase = CustomerUseCase()
    private let updateDefaultAddressUseCase = UpdateDefaultAddressUseCase()
    private let deleteAddressUseCase = DeleteAddressUseCase()
    
    var customerAddresses = Variable<[Address]>([])
    var customerDefaultAddress = Variable<Address?>(nil)
    var didSelectAddress = PublishSubject<Address>()
    var selectedAddress: Address?
    
    func loadCustomerAddresses(isTranslucentHud: Bool = false) {
        state.onNext(ViewState.make.loading(isTranslucent: isTranslucentHud))
        customerUseCase.getCustomer { [weak self] (customer, _) in
            guard let strongSelf = self else {
                return
            }
            if let addresses = customer?.addresses {
                strongSelf.customerDefaultAddress.value = customer?.defaultAddress
                strongSelf.customerAddresses.value = addresses
            }
            strongSelf.state.onNext(.content)
        }
    }
    
    func addressTuple(with address: Address) -> AddressTuple {
        let selected = selectedAddress?.isEqual(to: address) ?? false
        let isDefault = customerDefaultAddress.value?.isEqual(to: address) ?? false
        return (address, selected, isDefault)
    }
    
    func deleteCustomerAddress(with address: Address, type: AddressListType) {
        state.onNext(ViewState.make.loading(isTranslucent: true))
        deleteAddressUseCase.deleteCustomerAddress(with: address.id) { [weak self] (success, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let success = success, success {
                let selected = strongSelf.selectedAddress?.isEqual(to: address) ?? false
                strongSelf.processDeleteAddressResponse(with: selected, type: type)
                strongSelf.state.onNext(.content)
            } else {
                strongSelf.state.onNext(.content)
            }
        }
    }
    
    func updateCustomerDefaultAddress(with address: Address) {
        state.onNext(ViewState.make.loading(isTranslucent: true))
        updateDefaultAddressUseCase.updateDefaultAddress(with: address.id) { [weak self] (customer, error) in
            guard let strongSelf = self else {
                return
            }
            if let addresses = customer?.addresses, let defaultAddress = customer?.defaultAddress {
                strongSelf.customerDefaultAddress.value = defaultAddress
                strongSelf.customerAddresses.value = addresses
                strongSelf.state.onNext(.content)
            } else {
                strongSelf.state.onNext(.error(error: error))
            }
        }
    }
    
    func processDeleteAddressResponse(with isSelected: Bool, type: AddressListType) {
        loadCustomerAddresses(isTranslucentHud: true)
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
