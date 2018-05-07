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
        }
        
        describe("when view loaded") {
            it("should have default empty data view") {
                _ = viewController.view
                
                expect(viewController.customEmptyDataView).to(beAnInstanceOf(UIView.self))
            }
            
            it("should have correct error view delegate") {
                _ = viewController.view
                
                expect(viewController.errorView.delegate) === viewController
            }
            
            it("should have correct critical error view delegate") {
                _ = viewController.view
                
                expect(viewController.criticalErrorView.delegate) === viewController
            }
            
            it("should have correct offset in toast view's appearance") {
                _ = viewController.view
                
                expect(ToastView.appearance().bottomOffsetPortrait) == 80
            }
            
            context("if it pushed in navigation controller and not a root view controller") {
                it("should have correct back button image") {
                    let navigationController = NavigationController(rootViewController: UIViewController())
                    navigationController.pushViewController(viewController, animated: false)
                    _ = viewController.view
                    
                    expect(viewController.navigationItem.leftBarButtonItem?.image) == #imageLiteral(resourceName: "arrow_left")
                }
            }
            
            context("if it is a root view controller in navigation controller or hasn't navigation controller") {
                it("shouldn't have left bar button item") {
                    _ = viewController.view
                    
                    expect(viewController.navigationItem.leftBarButtonItem).to(beNil())
                }
            }
        }
        
        describe("when view state changed") {
            beforeEach {
                _ = viewController.view
            }
            
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
                        expect(viewController.view.subviews.contains(viewController.criticalErrorView)) == false
                    }
                }
                
                context("with type network") {
                    it("needs to hide all state views but error") {
                        viewModelMock.setNetworkErrorState()
                        
                        expect(viewController.view.subviews.contains(viewController.loadingView)) == false
                        expect(viewController.view.subviews.contains(viewController.errorView)) == true
                        expect(viewController.errorView.error).to(beAnInstanceOf(NetworkError.self))
                        expect(viewController.view.subviews.contains(viewController.criticalErrorView)) == false
                    }
                }
                
                context("with type non critical") {
                    it("needs to hide all state views and show toast") {
                        viewModelMock.setNonCriticalErrorState()
                        
                        expect(viewController.view.subviews.contains(viewController.loadingView)) == false
                        expect(viewController.view.subviews.contains(viewController.errorView)) == false
                        expect(viewController.view.subviews.contains(viewController.criticalErrorView)) == false
                        expect(ToastCenter.default.currentToast?.text) == "Error.Unknown".localizable
                    }
                }
                
                context("with type critical") {
                    it("needs to hide all state views and show critical error view") {
                        viewModelMock.setCriticalErrorState()
                        
                        expect(viewController.view.subviews.contains(viewController.loadingView)) == false
                        expect(viewController.view.subviews.contains(viewController.errorView)) == false
                        expect(viewController.view.subviews.contains(viewController.criticalErrorView)) == true
                    }
                }
                
                afterEach {
                    ToastCenter.default.cancelAll()
                }
            }
        }
    }
}
