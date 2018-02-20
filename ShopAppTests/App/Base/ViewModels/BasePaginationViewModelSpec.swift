//
//  BasePaginationViewModelSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class BasePaginationViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: BasePaginationViewModel!
        
        beforeEach {
            viewModel = BasePaginationViewModel()
        }
        
        describe("when view model initialized") {
            it("should have correct initial values of properties") {
                expect(viewModel.paginationValue).to(beNil())
                expect(viewModel.canLoadMore).to(beTrue())
            }
        }
    }
}
