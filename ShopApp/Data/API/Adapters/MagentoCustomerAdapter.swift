//
//  MagentoCustomerAdapter.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

struct MagentoCustomerAdapter {
    static func adapt(_ response: GetCustomerResponse) -> Customer {
        let addresses = response.addresses.map { MagentoAddressAdapter.adapt($0) }
        
        var defaultAddress: Address?
        if let index = response.addresses.index(where: { $0.isDefaultAddress ?? false == true }) {
            defaultAddress = addresses[index]
        }
        
        return Customer(id: "", email: response.email, firstName: response.firstName, lastName: response.lastName, isAcceptsMarketing: false, defaultAddress: defaultAddress, addresses: addresses)
    }
    
    static func update(_ customer: Customer, with countries: [Country]) -> Customer {
        let updatedAddresses: [Address] = customer.addresses.map { MagentoCustomerAdapter.update($0, with: countries) }
        
        var updatedDefaultAddress: Address?
        if let defaultAddress = customer.defaultAddress {
            updatedDefaultAddress = MagentoCustomerAdapter.update(defaultAddress, with: countries)
        }
        
        return Customer(id: customer.id, email: customer.email, firstName: customer.firstName, lastName: customer.lastName, phone: customer.phone, isAcceptsMarketing: false, defaultAddress: updatedDefaultAddress, addresses: updatedAddresses)
    }
    
    private static func update(_ address: Address, with countries: [Country]) -> Address {
        let countryName = countries.filter({ $0.id == address.country.id }).first?.name ?? ""
        let country = Country(id: address.country.id, name: countryName, states: address.country.states)
        
        var stateName: String!
        var state: State?
        if let id = address.state?.id {
            stateName = countries.filter({ $0.id == address.country.id }).first?.states?.filter({ $0.id == id }).first?.name ?? ""
            state = State(id: id, name: stateName)
        }
        
        return Address(id: address.id, firstName: address.firstName, lastName: address.lastName, street: address.street, secondStreet: address.secondStreet, city: address.city, country: country, state: state, zip: address.zip, phone: address.phone)
    }
}
