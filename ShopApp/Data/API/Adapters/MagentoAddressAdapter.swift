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
        let address = Address()
        address.id = String(response.id)
        address.firstName = response.firstName
        address.lastName = response.lastName
        address.address = response.streets.first
        address.city = response.city
        address.zip = response.postcode
        address.phone = response.telephone
        
        let country = Country()
        country.id = response.countryId
        address.country = country
        
        if response.streets.count > minNumberOfStreet {
            address.secondAddress = response.streets.last
        }
        
        if let regionId = response.regionId {
            let state = State()
            state.id = String(regionId)
            address.state = state
        }
        
        return address
    }
    
    static func adapt(_ address: Address, defaultAddress: Address? = nil) -> AddressRequestBody? {
        guard let countryId = address.country?.id, let firstName = address.firstName, let lastName = address.lastName, let mainStreet = address.address, let city = address.city, let postcode = address.zip, let telephone = address.phone else {
            return nil
        }
        
        let id = Int(address.id)
        let regionId = Int(address.state?.id ?? "")
        var streets = [mainStreet]
        var isDefaultAddress = false
        
        if let defaultAddress = defaultAddress, address.id == defaultAddress.id {
            isDefaultAddress = true
        }
        
        if let secondaryStreet = address.secondAddress, !secondaryStreet.isEmpty {
            streets.append(secondaryStreet)
        }
        
        return AddressRequestBody(id: id, countryId: countryId, firstName: firstName, lastName: lastName, streets: streets, city: city, regionId: regionId, postcode: postcode, telephone: telephone, isDefaultAddress: isDefaultAddress)
    }
    
    static func update(_ address: Address, with countries: [Country]) {
        address.country?.id = countries.filter({ $0.name == address.country?.name }).first?.id ?? ""
        address.state?.id = countries.filter({ $0.id == address.country?.id }).first?.states.filter({ $0.name == address.state?.name }).first?.id ?? ""
    }
    
    static func idOfAddedAddress(customerAddresses: [Address]?, responseAddresses: [AddressResponse]) -> String {
        let newIds = responseAddresses.map { String($0.id) }
        var id = ""
        
        if let customerAddresses = customerAddresses, !customerAddresses.isEmpty {
            let oldIds = customerAddresses.map { $0.id }
            id = newIds.filter({ !oldIds.contains($0) }).first ?? ""
        } else if let addressId = newIds.first {
            id = addressId
        }
        
        return id
    }
}
