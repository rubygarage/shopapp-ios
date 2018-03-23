//
//  CheckoutCartCollectionProviderSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CheckoutCartCollectionProviderSpec: QuickSpec {
    override func spec() {
        var collectionProvider: CheckoutCartCollectionProvider!
        var collectionViewLayout: UICollectionViewLayout!
        var collectionView: UICollectionView!
        
        beforeEach {
            collectionProvider = CheckoutCartCollectionProvider()
            collectionViewLayout = UICollectionViewLayout()
            collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
            collectionView.registerNibForCell(CheckoutCartCollectionCell.self)
            collectionView.dataSource = collectionProvider
            collectionView.delegate = collectionProvider
        }
        
        describe("when provider created") {
            it("should return correct rows count") {
                let itemsCount = collectionProvider.collectionView(collectionView, numberOfItemsInSection: 0)
                
                expect(itemsCount) == 0
            }
            
            it("should return correct cell size") {
                let indexPath = IndexPath(item: 0, section: 0)
                let cellSize = collectionProvider.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
                
                expect(cellSize) == CheckoutCartCollectionCell.cellSize
            }
        }
        
        describe("when items set") {
            beforeEach {
                collectionProvider.images = [Image(), Image()]
                collectionProvider.productVariantIds = ["firstId", "secondId"]
            }
            
            it("should return correct rows count") {
                let itemsCount = collectionProvider.collectionView(collectionView, numberOfItemsInSection: 0)
                
                expect(itemsCount) == collectionProvider.images.count
            }
            
            it("should return correct cell class") {
                let indexPath = IndexPath(item: 0, section: 0)
                let cell = collectionProvider.collectionView(collectionView, cellForItemAt: indexPath)
                
                expect(cell).to(beAnInstanceOf(CheckoutCartCollectionCell.self))
            }
        }
    }
}
