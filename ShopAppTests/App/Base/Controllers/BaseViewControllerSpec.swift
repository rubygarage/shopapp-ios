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
        var viewController: BaseViewController<BaseViewModel>!
        
        beforeEach {
            viewController = BaseViewController()
            viewController.viewModel = BaseViewModel()
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
                expect(ToastView.appearance().bottomOffsetPortrait).to(equal(80))
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
                    
                    viewController.viewModel.state.onNext(ViewState.content)
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
                    
                    viewController.viewModel.state.onNext(ViewState.empty)
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
                        
                        let state = ViewState.loading(showHud: false, isTranslucent: false)
                        viewController.viewModel.state.onNext(state)
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
                        
                        let state = ViewState.loading(showHud: true, isTranslucent: false)
                        viewController.viewModel.state.onNext(state)
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
                        
                        let state = ViewState.loading(showHud: true, isTranslucent: true)
                        viewController.viewModel.state.onNext(state)
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
                        
                        let error = RepoError()
                        let state = ViewState.error(error: error)
                        viewController.viewModel.state.onNext(state)
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
                        
                        let error = ContentError()
                        let state = ViewState.error(error: error)
                        viewController.viewModel.state.onNext(state)
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
                        
                        let error = NetworkError()
                        let state = ViewState.error(error: error)
                        viewController.viewModel.state.onNext(state)
                    }
                }
                
                context("with type non critical") {
                    it("needs to hide all state views and show toast") {
                        viewController.viewModel.state
                            .subscribe(onNext: { _ in
                                expect(viewController.view.subviews.contains(viewController.loadingView)).toEventually(beFalse())
                                expect(viewController.view.subviews.contains(viewController.errorView)).toEventually(beFalse())
                                expect(ToastCenter.default.currentToast).toNotEventually(beNil())
                            })
                            .disposed(by: disposeBag)
                        
                        let error = NonCriticalError()
                        let state = ViewState.error(error: error)
                        viewController.viewModel.state.onNext(state)
                    }
                }
                
                context("with type critical") {
                    it("needs to hide all state views and show toast") {
                        viewController.viewModel.state
                            .subscribe(onNext: { _ in
                                expect(viewController.view.subviews.contains(viewController.loadingView)).toEventually(beFalse())
                                expect(viewController.view.subviews.contains(viewController.errorView)).toEventually(beFalse())
                                expect(ToastCenter.default.currentToast).toNotEventually(beNil())
                            })
                            .disposed(by: disposeBag)
                        
                        let error = CriticalError(with: nil, message: "")
                        let state = ViewState.error(error: error)
                        viewController.viewModel.state.onNext(state)
                    }
                }
            }
        }
    }
}
