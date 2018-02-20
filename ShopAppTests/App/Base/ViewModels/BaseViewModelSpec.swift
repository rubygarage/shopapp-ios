//
//  BaseViewModelSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift

@testable import ShopApp

class BaseViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: BaseViewModel!
        
        beforeEach {
            viewModel = BaseViewModel()
        }
        
        describe("when view state changed") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            it("should have correct state in subscription closure") {
                viewModel.state
                    .subscribe(onNext: { state in
                        expect(state).toNotEventually(beNil())
                    })
                    .disposed(by: disposeBag)
                
                viewModel.state.onNext(ViewState.content)
            }
        }
    }
}
