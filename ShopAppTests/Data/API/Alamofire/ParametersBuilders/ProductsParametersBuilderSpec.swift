//
//  ProductsParametersBuilderSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/18/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class ProductsParametersBuilderSpec: QuickSpec {
    override func spec() {
        describe("when builder used") {
            it("needs to build coorect parameters") {
                let expectedParameters: [String : Any] = ["searchCriteria[filterGroups][0][filters][0][field]": "equal_pair_field",
                                                          "searchCriteria[filterGroups][0][filters][0][value]": "equal_pair_value",
                                                          "searchCriteria[filterGroups][0][filters][0][condition_type]": "eq",
                                                          "searchCriteria[filterGroups][1][filters][0][field]": "like_pair_field",
                                                          "searchCriteria[filterGroups][1][filters][0][value]": "like_pair_value",
                                                          "searchCriteria[filterGroups][1][filters][0][condition_type]": "like",
                                                          "searchCriteria[filterGroups][2][filters][0][field]": "pairs_first_field",
                                                          "searchCriteria[filterGroups][2][filters][0][value]": "pairs_first_value",
                                                          "searchCriteria[filterGroups][2][filters][0][condition_type]": "neq",
                                                          "searchCriteria[filterGroups][2][filters][1][field]": "pairs_second_field",
                                                          "searchCriteria[filterGroups][2][filters][1][value]": "pairs_second_value",
                                                          "searchCriteria[filterGroups][2][filters][1][condition_type]": "neq",
                                                          "searchCriteria[sortOrders][0][field]": "sort_order_field",
                                                          "searchCriteria[sortOrders][0][direction]": "DESC",
                                                          "searchCriteria[pageSize]": 50,
                                                          "searchCriteria[currentPage]": 2]
                
                let equalPair = (field: "equal_pair_field", value: "equal_pair_value")
                let likePair = (field: "like_pair_field", value: "like_pair_value")
                let pairs = [(field: "pairs_first_field", value: "pairs_first_value"), (field: "pairs_second_field", value: "pairs_second_value")]
                
                let parameters = ProductsParametersBuilder()
                    .addFilterParameters(pair: equalPair)
                    .addFilterParameters(pair: likePair, condition: .like)
                    .addFilterParameters(pairs: pairs, condition: .notEqual)
                    .addSortOrderParameters(field: "sort_order_field", isRevers: true)
                    .addPaginationParameters(pageSize: 50, currentPage: 2)
                    .build()
                
                expect(NSDictionary(dictionary: parameters).isEqual(to: expectedParameters)) == true
            }
        }
    }
}
