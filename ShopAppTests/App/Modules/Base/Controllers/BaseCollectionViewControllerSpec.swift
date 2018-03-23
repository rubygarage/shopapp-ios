//
//  BaseCollectionViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class BaseCollectionViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: BaseCollectionViewControllerTest!
        
        beforeEach {
            viewController = BaseCollectionViewControllerTest()
            _ = viewController.view
        }
        
        describe("when view loaded") {
            it("should have a correct superclass") {
                expect(viewController.isKind(of: BasePaginationViewController<BasePaginationViewModel>.self)) == true
            }
            
            it("should have refresh control") {
                expect(viewController.refreshControl).toNot(beNil())
            }
            
            it("should have collection view with refresh control") {
                expect(viewController.collectionView.refreshControl) === viewController.refreshControl
            }
        }
        
        describe("when load animation stopped") {
            it("needs to end refreshing") {
                viewController.refreshControl?.beginRefreshing()
                viewController.stopLoadAnimating()
                
                expect(viewController.refreshControl?.isRefreshing) == false
            }
        }
    }
}

class BaseCollectionViewControllerTest: BaseCollectionViewController<BasePaginationViewModel> {
    let collectionViewLayout = UICollectionViewLayout()
    
    lazy var testCollectionView: UICollectionView = {
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionViewLayout)
    }()
    
    override weak var collectionView: UICollectionView! {
        return testCollectionView
    }
}
