//
//  GridCollectionViewModelSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class GridCollectionViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: GridCollectionViewModel!
        
        beforeEach {
            viewModel = GridCollectionViewModel()
        }
        
        describe("when view model initialized") {
            it("should have a correct superclass") {
                expect(viewModel).to(beAKindOf(BasePaginationViewModel.self))
            }
            
            it("should have variable with a correct initial value") {
                expect(viewModel.products.value.isEmpty) == true
            }
        }
        
        describe("when products updated") {
            let products = [Product()]
            
            context("if it haven't pagination value") {
                it("needs to remove all products and append with new items") {
                    viewModel.paginationValue = nil
                    viewModel.products.value = products
                    viewModel.updateProducts(products: products)
                
                    expect(viewModel.products.value.count) == 1
                }
            }
            
            context("if it have pagination value") {
                it("needs to append with new items") {
                    viewModel.paginationValue = "pagination value"
                    viewModel.products.value = products
                    viewModel.updateProducts(products: products)

                    expect(viewModel.products.value.count) == 2
                }
            }
        }
    }
}
