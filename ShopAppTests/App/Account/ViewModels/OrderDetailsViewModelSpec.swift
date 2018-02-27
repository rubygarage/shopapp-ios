//
//  OrderDetailsViewModelSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class OrderDetailsViewModelSpec: QuickSpec {
    override func spec() {
        let repository = OrderRepositoryMock()
        let orderUseCase = OrderUseCaseMock(repository: repository)
        var viewModel: OrderDetailsViewModel!
        
        beforeEach {
            viewModel = OrderDetailsViewModel(orderUseCase: orderUseCase)
            viewModel.orderId = "order id"
        }
        
        describe("when view model initialized") {
            it("should have variables with correct initial values") {
                expect(viewModel.orderId) == "order id"
                expect(viewModel.data.value).to(beNil())
            }
        }
        
        describe("when data loaded") {
            it("should present loaded order") {
                let disposeBag = DisposeBag()
                viewModel.loadOrder()
                
                viewModel.data.asObservable()
                    .subscribe(onNext: { order in
                        expect(order?.id) == "order id"
                    })
                    .disposed(by: disposeBag)
            }
        }
        
        describe("when try again did press") {
            it("should present loaded order") {
                let disposeBag = DisposeBag()
                viewModel.tryAgain()
                
                viewModel.data.asObservable()
                    .subscribe(onNext: { order in
                        expect(order?.id) == "order id"
                    })
                    .disposed(by: disposeBag)
            }
        }
    }
}
