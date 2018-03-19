//
//  ImagesCarouselCollectionProviderSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ImagesCarouselCollectionProviderSpec: QuickSpec {
    override func spec() {
        var collectionProvider: ImagesCarouselCollectionProvider!
        var collectionViewLayout: UICollectionViewLayout!
        var collectionView: UICollectionView!
        
        beforeEach {
            collectionProvider = ImagesCarouselCollectionProvider()
            collectionViewLayout = UICollectionViewLayout()
            collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: collectionViewLayout)
            collectionView.registerNibForCell(DetailsImagesCollectionViewCell.self)
            collectionView.dataSource = collectionProvider
            collectionView.delegate = collectionProvider
        }
        
        describe("when provider initialized") {
            it("should have correct properties") {
                expect(collectionProvider.images.isEmpty) == true
                expect(collectionProvider.sizeForCell) == CGSize.zero
            }
            
            it("should return correct items count") {
                let itemsCount = collectionProvider.collectionView(collectionView, numberOfItemsInSection: 0)
                
                expect(itemsCount) == 0
            }
            
            it("should return correct cell size") {
                let indexPath = IndexPath(item: 0, section: 0)
                let cellSize = collectionProvider.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
                
                expect(cellSize) == collectionProvider.sizeForCell
            }
        }
        
        describe("when images did set") {
            let images = [Image()]
            
            beforeEach {
                collectionProvider.images = images
            }
            
            it("should return correct items count") {
                let itemsCount = collectionProvider.collectionView(collectionView, numberOfItemsInSection: 0)
                
                expect(itemsCount) == images.count
            }
            
            it("should return correct cell class") {
                let indexPath = IndexPath(item: 0, section: 0)
                let cell = collectionProvider.collectionView(collectionView, cellForItemAt: indexPath)
                
                expect(cell).to(beAnInstanceOf(DetailsImagesCollectionViewCell.self))
            }
        }
        
        describe("when scroll view did end decelerating") {
            var delegateMock: ImagesCarouselCollectionProviderDelegateMock!
            
            beforeEach {
                delegateMock = ImagesCarouselCollectionProviderDelegateMock()
                collectionProvider.delegate = delegateMock
            }
            
            it("should set scrolling image index") {
                collectionProvider.scrollViewDidEndDecelerating(collectionView)
                
                expect(delegateMock.provider) === collectionProvider
                expect(delegateMock.index) == 0
            }
        }
    }
}
