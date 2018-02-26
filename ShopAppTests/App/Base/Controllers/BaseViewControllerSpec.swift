//
//  BaseViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
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
            context("if it content state") {
                it("needs to hide all state views") {
                    viewModelMock.setContentState()
                    
                    expect(viewController.view.subviews.contains(viewController.loadingView)) == false
                    expect(viewController.view.subviews.contains(viewController.errorView)) == false
                }
            }
            
            context("if it empty state") {
                it("needs to hide all state views but empty") {
                    viewModelMock.setEmptyState()
                    
                    expect(viewController.view.subviews.contains(viewController.loadingView)) == false
                    expect(viewController.view.subviews.contains(viewController.errorView)) == false
                }
            }
            
            context("if it loading state") {
                context("without hud") {
                    it("needs to hide all state views") {
                        viewModelMock.setLoadingState(showHud: false)
                        
                        expect(viewController.view.subviews.contains(viewController.loadingView)) == false
                        expect(viewController.view.subviews.contains(viewController.errorView)) == false
                    }
                }
                
                context("with hud") {
                    it("needs to hide all state views but loading") {
                        viewModelMock.setLoadingState()
                        
                        expect(viewController.view.subviews.contains(viewController.loadingView)) == true
                        expect(viewController.loadingView.alpha) == 1
                        expect(viewController.view.subviews.contains(viewController.errorView)) == false
                    }
                }
                
                context("with translucent hud") {
                    it("needs to hide all state views but translucent loading") {
                        viewModelMock.setLoadingState(showHud: true, isTranslucent: true)
                        
                        expect(viewController.view.subviews.contains(viewController.loadingView)) == true
                        expect(viewController.loadingView.alpha) == 0.75
                        expect(viewController.view.subviews.contains(viewController.errorView)) == false
                    }
                }
            }
            
            context("if it error state") {
                context("with type repo") {
                    it("needs to hide all state views") {
                        viewModelMock.setRepoErrorState()
                        
                        expect(viewController.view.subviews.contains(viewController.loadingView)) == false
                        expect(viewController.view.subviews.contains(viewController.errorView)) == false
                    }
                }
                
                context("with type content") {
                    it("needs to hide all state views but error") {
                        viewModelMock.setContentErrorState()
                        
                        expect(viewController.view.subviews.contains(viewController.loadingView)) == false
                        expect(viewController.view.subviews.contains(viewController.errorView)) == true
                        expect(viewController.errorView.error).to(beAnInstanceOf(ContentError.self))
                    }
                }
                
                context("with type network") {
                    it("needs to hide all state views but error") {
                        viewModelMock.setNetworkErrorState()
                        
                        expect(viewController.view.subviews.contains(viewController.loadingView)) == false
                        expect(viewController.view.subviews.contains(viewController.errorView)) == true
                        expect(viewController.errorView.error).to(beAnInstanceOf(NetworkError.self))
                    }
                }
                
                context("with type non critical") {
                    it("needs to hide all state views and show toast") {
                        viewModelMock.setNonCriticalErrorState()
                        
                        expect(viewController.view.subviews.contains(viewController.loadingView)) == false
                        expect(viewController.view.subviews.contains(viewController.errorView)) == false
                        expect(ToastCenter.default.currentToast).toNot(beNil())
                    }
                }
                
                context("with type critical") {
                    it("needs to hide all state views and show toast") {
                        viewModelMock.setCriticalErrorState()
                        
                        expect(viewController.view.subviews.contains(viewController.loadingView)) == false
                        expect(viewController.view.subviews.contains(viewController.errorView)) == false
                        expect(ToastCenter.default.currentToast).toNot(beNil())
                    }
                }
            }
        }
    }
}
