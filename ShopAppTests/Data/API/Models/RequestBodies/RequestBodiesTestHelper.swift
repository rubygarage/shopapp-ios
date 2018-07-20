//
//  RequestBodiesTestHelper.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

@testable import ShopApp

struct RequestBodiesTestHelper {
    static var addressRequestBody: AddressRequest {
        return AddressRequest(id: 0, countryId: "id", firstName: "first", lastName: "last", streets: ["street"], city: "city", regionId: 1, postcode: "postcode", telephone: "telephone", isDefaultAddress: true)
    }
    
    static var customerRequestBody: CustomerRequestBody {
        return CustomerRequestBody(email: "user@mail.com", firstName: "first", lastName: "last", addresses: [addressRequestBody])
    }
    
    static var resetPasswordRequestBody: ResetPasswordRequestBody {
        return ResetPasswordRequestBody(email: "user@mail.com")
    }
    
    static var updateCustomerRequestBody: UpdateCustomerRequest {
        return UpdateCustomerRequest(customer: customerRequestBody)
    }
}
