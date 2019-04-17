//
//  ImagesCarouselViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ImagesCarouselViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: ImagesCarouselViewController!
        var collectionProvider: ImagesCarouselCollectionProvider!
        var collectionView: UICollectionView!
        var pageControl: UIPageControl!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.main, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.imagesCarousel) as? ImagesCarouselViewController
            
            collectionProvider = ImagesCarouselCollectionProvider()
            viewController.collectionProvider = collectionProvider
            
            collectionView = self.findView(withAccessibilityLabel: "carouselCollectionView", in: viewController.view) as? UICollectionView
            pageControl = self.findView(withAccessibilityLabel: "pageControl", in: viewController.view) as? UIPageControl
        }
        
        describe("when view loaded") {
            it("should have correct superclass") {
                expect(viewController).to(beAKindOf(UIViewController.self))
            }
            
            it("should have correct collection provider class") {
                expect(viewController.collectionProvider).to(beAnInstanceOf(ImagesCarouselCollectionProvider.self))
            }
            
            it("should have correct data source and delegate of table view") {
                expect(collectionView.dataSource) === collectionProvider
                expect(collectionView.delegate) === collectionProvider
            }
            
            it("should have correct initial properties") {
                expect(viewController.showingIndex) == 0
                expect(viewController.images.isEmpty) == true
            }
            
            it("should have correct page control current page") {
                expect(pageControl.currentPage) == 0
            }
        }
        
        describe("when images did set") {
            var images: [Image]!
            
            beforeEach {
                images = [Image()]
                viewController.images = images
            }
            
            it("should return correct items count") {
                expect(collectionView.numberOfItems(inSection: 0)) == 1
            }
            
            it("should have correct page control number of pages") {
                expect(pageControl.numberOfPages) == images.count
            }
            
            it("should set collection provider images") {
                expect(viewController.collectionProvider.images) === viewController.images
            }
            
            it("should set cell size to provider") {
                expect(viewController.collectionProvider.sizeForCell) == viewController.view.frame.size
            }
        }
        
        describe("when image did select") {
            let delegateMock = ImagesCarouselViewControllerDelegateMock()
            
            beforeEach {
                viewController.delegate = delegateMock
            }
            
            it("should pass showing index") {
                let tapRecognizer = UITapGestureRecognizer()
                viewController.imageDidTap(tapRecognizer)
                
                expect(delegateMock.viewController) === viewController
                expect(delegateMock.index) == viewController.showingIndex
            }
        }
        
        describe("when page control did change value") {
            var images: [Image]!
            
            beforeEach {
                images = [Image()]
                viewController.images = images
            }
            
            it("should update showing image") {
                viewController.pageControlValueDidChange(pageControl)
                
                expect(viewController.showingIndex) == pageControl.currentPage
            }
        }
        
        describe("when carousel did scroll") {
            var images: [Image]!
            
            beforeEach {
                images = [Image(), Image()]
                viewController.images = images
            }
            
            it("should update current index") {
                viewController.provider(collectionProvider, didScrollToImageAt: 1)
                
                expect(pageControl.currentPage) == 1
                expect(viewController.showingIndex) == 1
            }
        }
    }
}
