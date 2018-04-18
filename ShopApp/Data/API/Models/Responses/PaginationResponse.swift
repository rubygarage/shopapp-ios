//
//  PaginationResponse.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 5/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

protocol PaginationResponse: Response {
    var totalCount: Int { get }
    func nextPaginationValue(perPage: Int, currentPaginationValue: Int) -> Int?
}

extension PaginationResponse {
    func nextPaginationValue(perPage: Int, currentPaginationValue: Int) -> Int? {
        return totalCount >= perPage * currentPaginationValue ? currentPaginationValue + 1 : nil
    }
}
