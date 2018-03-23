//
//  GridCollectionViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/7/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class GridCollectionViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: GridCollectionViewControllerTest!
        
        beforeEach {
            viewController = GridCollectionViewControllerTest()
            _ = viewController.view
        }
        
        describe("when view loaded") {
            it("should have a correct superclass") {
                expect(viewController.isKind(of: BaseCollectionViewController<GridCollectionViewModel>.self)) == true
            }
            
            it("should have correct delegate of collection provider") {
                expect(viewController.collectionProvider.delegate) === viewController
            }
            
            it("should have correct data source and delegate of collection view") {
                expect(viewController.collectionView.dataSource) === viewController.collectionProvider
                expect(viewController.collectionView.delegate) === viewController.collectionProvider
            }
            
            it("should have correct content inset of collection view") {
                expect(viewController.collectionView.contentInset) == GridCollectionViewCell.defaultCollectionViewInsets
            }
        }
    }
}

class GridCollectionViewControllerTest: GridCollectionViewController<GridCollectionViewModel> {
    let collectionViewLayout = UICollectionViewLayout()
    
    lazy var testCollectionView: UICollectionView = {
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionViewLayout)
    }()
    
    override weak var collectionView: UICollectionView! {
        return testCollectionView
    }
}
