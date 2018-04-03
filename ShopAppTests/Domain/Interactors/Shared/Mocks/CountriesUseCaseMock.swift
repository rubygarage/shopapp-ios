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
    
    override func getCountries(_ callback: @escaping RepoCallback<[Country]>) {
        var countries: [Country] = []
        for index in 1...2 {
            let country = Country()
            country.name = "Country\(index)"
            if returnStates && index == 1 {
                let state = State()
                state.name = "State1"
                country.states = [state]
            }
            countries.append(country)
        }
        callback(countries, nil)
    }
}
