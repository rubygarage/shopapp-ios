//
//  CartButtonViewModelSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/15/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift

@testable import ShopApp

class CartButtonViewModelSpec: QuickSpec {
    override func spec() {
        let repositoryMock = CartRepositoryMock()
        let cartProductListUseCaseMock = CartProductListUseCaseMock(repository: repositoryMock)
        
        var viewModel: CartButtonViewModel!
        
        beforeEach {
            viewModel = CartButtonViewModel(cartProductListUseCase: cartProductListUseCaseMock)
        }
        
        describe("when cart item count got") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            it("needs to notify subscriber") {
                viewModel.getCartItemsCount()
                
                viewModel.cartItemsCount
                    .subscribe(onNext: { count in
                        expect(count) == 1
                    })
                    .disposed(by: disposeBag)
            }
        }
    }
}
