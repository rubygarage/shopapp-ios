//
//  ProductOptionsViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ProductOptionsViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: ProductOptionsViewController!
        var collectionProvider: ProductOptionsCollectionProvider!
        var collectionView: UICollectionView!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.main, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.productOptions) as! ProductOptionsViewController
            
            collectionProvider = ProductOptionsCollectionProvider()
            viewController.collectionProvider = collectionProvider
            
            collectionView = self.findView(withAccessibilityLabel: "productOptionsCollectionView", in: viewController.view) as! UICollectionView
        }
        
        describe("when view loaded") {
            it("should have correct superclass") {
                expect(viewController).to(beAKindOf(UIViewController.self))
            }
            
            it("should have correct collection provider class") {
                expect(viewController.collectionProvider).to(beAnInstanceOf(ProductOptionsCollectionProvider.self))
            }
            
            it("should have correct data source and delegate of table view") {
                expect(collectionView.dataSource) === collectionProvider
                expect(collectionView.delegate) === collectionProvider
            }
            
            it("should have correct collection provider delegate") {
                expect(collectionProvider.delegate) === viewController
            }
            
            it("should have correct initial properties") {
                expect(viewController.options.isEmpty) == true
                expect(viewController.selectedOptions.isEmpty) == true
            }
        }
        
        describe("when options did set") {
            var options: [ProductOption]!
            var selectedOptions: [SelectedOption]!
            
            beforeEach {
                let option = ProductOption()
                option.values = ["Value 1", "Value 2", "Value 3"]
                options = [option]
                
                selectedOptions = [SelectedOption(name: "Name", value: "Value")]
                
                viewController.options = options
                viewController.selectedOptions = selectedOptions
            }
            
            it("should pass data to collection provider") {
                expect(viewController.collectionProvider.options) === viewController.options
                expect(viewController.collectionProvider.selectedOptions.first?.name) == viewController.selectedOptions.first?.name
                expect(viewController.collectionProvider.selectedOptions.first?.value) == viewController.selectedOptions.first?.value
            }
            
            it("should have correct sections count") {
                expect(collectionView.numberOfSections) == options.count
            }
            
            it("should have correct items count") {
                expect(collectionView.numberOfItems(inSection: 0)) == 1
            }
        }
        
        describe("when height calculated") {
            var delegateMock: ProductOptionsControllerDelegateMock!
            
            beforeEach {
                delegateMock = ProductOptionsControllerDelegateMock()
                viewController.delegate = delegateMock
            }
            
            context("if controller has only 1 option and 1 option value") {
                beforeEach {
                    let option = ProductOption()
                    option.values = ["Value"]
                    viewController.options = [option]
                }
                
                it("should pass zero height to delegate") {
                    viewController.selectedOptions = [SelectedOption(name: "Name", value: "Value")]
                    
                    expect(delegateMock.viewController) === viewController
                    expect(delegateMock.height) == 0
                }
            }
            
            context("if selected options count more than 1") {
                var options: [ProductOption]!
                
                beforeEach {
                    let option =  ProductOption()
                    options = [option]
                    viewController.options = options
                }
                
                it("should pass height with additional height to delegate") {
                    let option = SelectedOption(name: "Name", value: "Value")
                    viewController.selectedOptions = [option]
                    
                    let collectionViewHeight = (kOptionCollectionViewHeaderHeight + kOptionCollectionViewCellHeight) * CGFloat(viewController.options.count)
                    let additionalHeight: CGFloat = 20 // 20 is optionCollectionViewAdditionalHeight private constant
                    let expectedHeight = collectionViewHeight + additionalHeight
                    
                    expect(delegateMock.viewController) === viewController
                    expect(delegateMock.height) == expectedHeight
                }
            }
            
            context("if options count is 0") {
                it("should pass height without additional height to delegate") {
                    let option = SelectedOption(name: "Name", value: "Value")
                    viewController.selectedOptions = [option]
                    
                    let collectionViewHeight = (kOptionCollectionViewHeaderHeight + kOptionCollectionViewCellHeight) * CGFloat(viewController.options.count)
                    
                    expect(delegateMock.viewController) === viewController
                    expect(delegateMock.height) == collectionViewHeight
                }
            }
        }
        
        describe("when option selected") {
            var delegateMock: ProductOptionsControllerDelegateMock!
            var option: ProductOption!
            
            beforeEach {
                delegateMock = ProductOptionsControllerDelegateMock()
                viewController.delegate = delegateMock
                
                option = ProductOption()
                option.name = "Name"
                option.values = ["Value 1", "Value 2"]
                viewController.options = [option]
            }
            
            it("should pass selected option to delegate") {
                let cell = ProductOptionsCollectionViewCell()
                let selectedValue = option.values?.first
                viewController.collectionViewCell(cell, didSelectItemWith: option.values!, selectedValue: selectedValue!)
                
                expect(delegateMock.viewController) == viewController
                expect(delegateMock.option?.name) == option.name
                expect(delegateMock.option?.value) == selectedValue
            }
        }
    }
}
