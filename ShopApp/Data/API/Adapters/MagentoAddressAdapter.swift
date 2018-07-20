//
//  MagentoAddressAdapter.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

struct MagentoAddressAdapter {
    private static let minNumberOfStreet = 1
    
    static func adapt(_ response: AddressResponse) -> Address {
        let id = String(response.id)
        let street = response.streets.first ?? ""
        let secondStreet = response.streets.count > minNumberOfStreet ? response.streets.last : nil
        let country = Country(id: response.countryId, name: "")
        
        var state: State?
        if let regionId = response.regionId {
            let id = String(regionId)
            state = State(id: id, name: "")
        }
        
        return Address(id: id, firstName: response.firstName, lastName: response.lastName, street: street, secondStreet: secondStreet, city: response.city, country: country, state: state, zip: response.postcode, phone: response.telephone)
    }
    
    static func adapt(_ address: Address, defaultAddress: Address? = nil) -> AddressRequest? {
        guard let telephone = address.phone else {
            return nil
        }
        
        let id = Int(address.id)
        let regionId = Int(address.state?.id ?? "")
        
        var isDefaultAddress = false
        if let defaultAddress = defaultAddress, address.id == defaultAddress.id {
            isDefaultAddress = true
        }
        
        var streets = [address.street]
        if let secondStreet = address.secondStreet, !secondStreet.isEmpty {
            streets.append(secondStreet)
        }
        
        return AddressRequest(id: id, countryId: address.country.id, firstName: address.firstName, lastName: address.lastName, streets: streets, city: address.city, regionId: regionId, postcode: address.zip, telephone: telephone, isDefaultAddress: isDefaultAddress)
    }
    
    static func update(_ address: Address, with countries: [Country]) -> Address {
        let countryId = countries.filter({ $0.name == address.country.name }).first?.id ?? ""
        let country = Country(id: countryId, name: address.country.name)
        
        var stateId: String!
        var state: State?
        if let addressState = address.state {
            stateId = countries.filter({ $0.id == countryId }).first?.states?.filter({ $0.name == addressState.name }).first?.id ?? ""
            state = State(id: stateId, name: addressState.name)
        }

        return Address(id: address.id, firstName: address.firstName, lastName: address.lastName, street: address.street, secondStreet: address.secondStreet, city: address.city, country: country, state: state, zip: address.zip, phone: address.phone)
    }
}
