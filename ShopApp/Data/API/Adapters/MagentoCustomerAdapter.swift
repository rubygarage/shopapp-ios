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
        let customer = Customer()
        customer.email = response.email
        customer.firstName = response.firstName
        customer.lastName = response.lastName
        customer.addresses = response.addresses.map { MagentoAddressAdapter.adapt($0) }
        
        if let index = response.addresses.index(where: { $0.isDefaultAddress ?? false == true }) {
            customer.defaultAddress = customer.addresses?[index]
        }
        
        return customer
    }
    
    static func update(_ customer: Customer, with countries: [Country]) {
        customer.addresses?.forEach { address in
            if let id = address.country?.id {
                address.country?.name = countries.filter({ $0.id == id }).first?.name ?? ""
            }
            
            if let id = address.state?.id {
                address.state?.name = countries.filter({ $0.id == address.country?.id }).first?.states.filter({ $0.id == id }).first?.name ?? ""
            }
        }
    }
}
