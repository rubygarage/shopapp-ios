//
//  CountriesUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/26/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class CountriesUseCaseMock: CountriesUseCase {
    var returnStates = false
    
    override func getCountries(_ callback: @escaping ApiCallback<[Country]>) {
        var countries: [Country] = []
        for index in 1...2 {
            var stateName: String?
            let countryName = "Country\(index)"
            if returnStates && index == 1 {
                stateName = "State1"
            }
            let states = stateName != nil ? [State(id: "id", name: stateName!)] : nil
            countries.append(Country(id: "id", name: countryName, states: states))
        }
        callback(countries, nil)
    }
}
