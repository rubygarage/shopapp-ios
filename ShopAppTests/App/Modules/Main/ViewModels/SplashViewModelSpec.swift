//
//  SplashViewModelSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 4/25/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift

@testable import ShopApp

class SplashViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: SplashViewModel!
        var setupProviderUseCaseMock: SetupProviderUseCaseMock!
        
        beforeEach {
            let setupProviderRepositoryMock = SetupProviderRepositoryMock()
            setupProviderUseCaseMock = SetupProviderUseCaseMock(repository: setupProviderRepositoryMock)
            
            viewModel = SplashViewModel(setupProviderUseCase: setupProviderUseCaseMock)
        }
        
        describe("when view model initialized") {
            it("should have correct superclass") {
                expect(viewModel).to(beAKindOf(BaseViewModel.self))
            }
        }
        
        describe("when data loaded") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if data loaded succesfully") {
                it("should notify about finish loading") {
                    setupProviderUseCaseMock.isNeedToReturnError = false
                    
                    viewModel.providerDidSetup
                        .subscribe(onNext: { event in
                            expect(event).toNotEventually(beNil())
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.setupProvider()
                }
            }
            
            context("if error occured") {
                it("should notify about finish loading") {
                    setupProviderUseCaseMock.isNeedToReturnError = true
                    
                    viewModel.providerDidSetup
                        .subscribe(onNext: { event in
                            expect(event).toNotEventually(beNil())
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.setupProvider()
                }
            }
        }
        
        describe("when try again did press") {
            it("should start data loading") {
                let disposeBag = DisposeBag()
                
                setupProviderUseCaseMock.isNeedToReturnError = false
                
                viewModel.providerDidSetup
                    .subscribe(onNext: { event in
                        expect(event).toNotEventually(beNil())
                    })
                .disposed(by: disposeBag)
                
                viewModel.tryAgain()
            }
        }
    }
}
