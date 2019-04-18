//
//  CartButtonViewSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/15/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CartButtonViewSpec: QuickSpec {
    override func spec() {
        var view: CartButtonView!
        var viewModelMock: CartButtonViewModelMock!
        var itemsCountLabel: UILabel!
        var itemsCountBackgroundView: UIView!
        
        beforeEach {
            view = CartButtonView()
            
            let repositoryMock = CartRepositoryMock()
            let cartProductListUseCaseMock = CartProductListUseCaseMock(repository: repositoryMock)
            viewModelMock = CartButtonViewModelMock(cartProductListUseCase: cartProductListUseCaseMock)
            view.viewModel = viewModelMock
            
            itemsCountLabel = self.findView(withAccessibilityLabel: "count", in: view) as? UILabel
            itemsCountBackgroundView = self.findView(withAccessibilityLabel: "background", in: view)
        }
        
        describe("when view initialized") {
            it("should have correct count label state") {
                expect(itemsCountLabel.text) == "0"
                expect(itemsCountLabel.isHidden) == true
            }
            
            it("should have correct background view state") {
                expect(itemsCountBackgroundView.isHidden) == true
                expect(itemsCountBackgroundView.layer.cornerRadius) == 7
            }
            
            it("should start getting count") {
                expect(viewModelMock.isGettingCountStarted) == true
            }
        }
        
        describe("when cart item count got") {
            it("needs to setup count label and background view") {
                viewModelMock.isNeedToReturnCount = true
                viewModelMock.getCartItemsCount()
                
                expect(itemsCountLabel.text) == "1"
                expect(itemsCountLabel.isHidden) == false
                expect(itemsCountBackgroundView.isHidden) == false
            }
        }
    }
}
