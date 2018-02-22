//
//  BaseViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import ShopApp_Gateway
import Toaster

@testable import ShopApp

class BaseViewControllerSpec: QuickSpec {
    override func spec() {
        let viewModelMock = BaseViewModelMock()
        
        var viewController: BaseViewController<BaseViewModel>!
        
        beforeEach {
            viewController = BaseViewController()
            viewController.viewModel = viewModelMock
            _ = viewController.view
        }
        
        describe("when view loaded") {
            it("shouldn't have left bar button item") {
                expect(viewController.navigationItem.leftBarButtonItem).to(beNil())
            }
            
            it("should have default empty data view") {
                expect(viewController.customEmptyDataView).to(beAnInstanceOf(UIView.self))
            }
            
            it("should have correct offset in toast view's appearance") {
                expect(ToastView.appearance().bottomOffsetPortrait) == 80
            }
        }
        
        describe("when view state changed") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if it content state") {
                it("needs to hide all state views") {
                    viewController.viewModel.state
                        .subscribe(onNext: { _ in
                            expect(viewController.view.subviews.contains(viewController.loadingView)).toEventually(beFalse())
                            expect(viewController.view.subviews.contains(viewController.errorView)).toEventually(beFalse())
                        })
                        .disposed(by: disposeBag)
                    
                    viewModelMock.setContentState()
                }
            }
            
            context("if it empty state") {
                it("needs to hide all state views but empty") {
                    viewController.viewModel.state
                        .subscribe(onNext: { _ in
                            expect(viewController.view.subviews.contains(viewController.loadingView)).toEventually(beFalse())
                            expect(viewController.view.subviews.contains(viewController.errorView)).toEventually(beFalse())
                        })
                        .disposed(by: disposeBag)
                    
                    viewModelMock.setEmptyState()
                }
            }
            
            context("if it loading state") {
                context("without hud") {
                    it("needs to hide all state views") {
                        viewController.viewModel.state
                            .subscribe(onNext: { _ in
                                expect(viewController.view.subviews.contains(viewController.loadingView)).toEventually(beFalse())
                                expect(viewController.view.subviews.contains(viewController.errorView)).toEventually(beFalse())
                            })
                            .disposed(by: disposeBag)
                        
                        viewModelMock.setLoadingState(showHud: false)
                    }
                }
                
                context("with hud") {
                    it("needs to hide all state views but loading") {
                        viewController.viewModel.state
                            .subscribe(onNext: { _ in
                                expect(viewController.view.subviews.contains(viewController.loadingView)).toEventually(beTrue())
                                expect(viewController.loadingView.alpha).toEventually(equal(1))
                                expect(viewController.view.subviews.contains(viewController.errorView)).toEventually(beFalse())
                            })
                            .disposed(by: disposeBag)
                        
                        viewModelMock.setLoadingState()
                    }
                }
                
                context("with translucent hud") {
                    it("needs to hide all state views but translucent loading") {
                        viewController.viewModel.state
                            .subscribe(onNext: { _ in
                                expect(viewController.view.subviews.contains(viewController.loadingView)).toEventually(beTrue())
                                expect(viewController.loadingView.alpha).toEventually(equal(0.75))
                                expect(viewController.view.subviews.contains(viewController.errorView)).toEventually(beFalse())
                            })
                            .disposed(by: disposeBag)
                        
                        viewModelMock.setLoadingState(showHud: true, isTranslucent: true)
                    }
                }
            }
            
            context("if it error state") {
                context("with type repo") {
                    it("needs to hide all state views") {
                        viewController.viewModel.state
                            .subscribe(onNext: { _ in
                                expect(viewController.view.subviews.contains(viewController.loadingView)).toEventually(beFalse())
                                expect(viewController.view.subviews.contains(viewController.errorView)).toEventually(beFalse())
                            })
                            .disposed(by: disposeBag)
                        
                        viewModelMock.setRepoErrorState()
                    }
                }
                
                context("with type content") {
                    it("needs to hide all state views but error") {
                        viewController.viewModel.state
                            .subscribe(onNext: { _ in
                                expect(viewController.view.subviews.contains(viewController.loadingView)).toEventually(beFalse())
                                expect(viewController.view.subviews.contains(viewController.errorView)).toEventually(beTrue())
                                expect(viewController.errorView.error).toEventually(beAnInstanceOf(ContentError.self))
                            })
                            .disposed(by: disposeBag)
                        
                        viewModelMock.setContentErrorState()
                    }
                }
                
                context("with type network") {
                    it("needs to hide all state views but error") {
                        viewController.viewModel.state
                            .subscribe(onNext: { _ in
                                expect(viewController.view.subviews.contains(viewController.loadingView)).toEventually(beFalse())
                                expect(viewController.view.subviews.contains(viewController.errorView)).toEventually(beTrue())
                                expect(viewController.errorView.error).toEventually(beAnInstanceOf(NetworkError.self))
                            })
                            .disposed(by: disposeBag)
                        
                        viewModelMock.setNetworkErrorState()
                    }
                }
                
                context("with type non critical") {
                    it("needs to hide all state views and show toast") {
                        viewController.viewModel.state
                            .subscribe(onNext: { _ in
                                expect(viewController.view.subviews.contains(viewController.loadingView)).toEventually(beFalse())
                                expect(viewController.view.subviews.contains(viewController.errorView)).toEventually(beFalse())
                                expect(ToastCenter.default.currentToast).toEventuallyNot(beNil())
                            })
                            .disposed(by: disposeBag)
                        
                        viewModelMock.setNonCriticalErrorState()
                    }
                }
                
                context("with type critical") {
                    it("needs to hide all state views and show toast") {
                        viewController.viewModel.state
                            .subscribe(onNext: { _ in
                                expect(viewController.view.subviews.contains(viewController.loadingView)).toEventually(beFalse())
                                expect(viewController.view.subviews.contains(viewController.errorView)).toEventually(beFalse())
                                expect(ToastCenter.default.currentToast).toEventuallyNot(beNil())
                            })
                            .disposed(by: disposeBag)
                        
                        viewModelMock.setCriticalErrorState()
                    }
                }
            }
        }
    }
}
