//
//  CountryRepository.swift
//  ShopApp
//
//  Created by Mykola Voronin on 6/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

protocol CountryRepository {
    func getCountries(callback: @escaping ApiCallback<[Country]>)
}
