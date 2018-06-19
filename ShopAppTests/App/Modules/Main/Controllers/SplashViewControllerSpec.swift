//
//  SplashViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 4/25/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class SplashViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: SplashViewController!
        var viewModelMock: SplashViewModelMock!
        var titleLabel: UILabel!
        var loadingLabel: UILabel!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.navigation, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.splash) as! SplashViewController
            
            let repository = SetupProviderRepositoryMock()
            let setupProviderUseCaseMock = SetupProviderUseCaseMock(repository: repository)
            viewModelMock = SplashViewModelMock(setupProviderUseCase: setupProviderUseCaseMock)
            viewController.viewModel = viewModelMock
            
            titleLabel = self.findView(withAccessibilityLabel: "titleLabel", in: viewController.view) as! UILabel
            loadingLabel = self.findView(withAccessibilityLabel: "loadingLabel", in: viewController.view) as! UILabel
        }
        
        describe("when view loaded") {
            it("should have a correct superclass") {
                expect(viewController).to(beAKindOf(BaseViewController<SplashViewModel>.self))
            }
            
            it("should have correct view model class") {
                expect(viewController.viewModel).to(beAKindOf(SplashViewModel.self))
            }
            
            it("should have correct title label") {
                expect(titleLabel.text) == "Label.ShopApp".localizable
            }
            
            it("should have correct loading label") {
                expect(loadingLabel.text) == "Label.Loading".localizable
            }
            
            it("should start data loading") {
                expect(viewModelMock.isLoadDataStarted) == true
            }
        }
    }
}
