//
//  GridCollectionViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class GridCollectionViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: GridCollectionViewController<GridCollectionViewModel>!
        
        beforeEach {
            viewController = GridCollectionViewController()
            viewController.viewModel = GridCollectionViewModel()
            _ = viewController.view
        }
        
        describe("when view loaded") {
            it("should have collection provider") {
                expect(viewController.collectionProvider).toNot(beNil())
            }
        }
    }
}
