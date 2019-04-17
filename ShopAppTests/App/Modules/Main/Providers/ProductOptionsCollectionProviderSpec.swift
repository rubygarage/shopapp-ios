//
//  ProductOptionsCollectionProviderSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ProductOptionsCollectionProviderSpec: QuickSpec {
    override func spec() {
        var collectionProvider: ProductOptionsCollectionProvider!
        var collectionViewLayout: UICollectionViewLayout!
        var collectionView: UICollectionView!
        
        beforeEach {
            collectionProvider = ProductOptionsCollectionProvider()
            collectionViewLayout = UICollectionViewLayout()
            collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: collectionViewLayout)
            collectionView.registerNibForCell(ProductOptionsCollectionViewCell.self)
            collectionView.registerNibForSupplementaryView(ProductOptionHeaderView.self, of: UICollectionView.elementKindSectionHeader)
            collectionView.dataSource = collectionProvider
            collectionView.delegate = collectionProvider
        }
        
        describe("when provider initialized") {
            it("should have correct properties") {
                expect(collectionProvider.options.isEmpty) == true
                expect(collectionProvider.selectedOptions.isEmpty) == true
            }
            
            it("should have correct sections count") {
                let sectionsCount = collectionProvider.numberOfSections(in: collectionView)
                
                expect(sectionsCount) == 0
            }
            
            it("should return correct items count") {
                let itemsCount = collectionProvider.collectionView(collectionView, numberOfItemsInSection: 0)
                
                expect(itemsCount) == 0
            }
            
            it("should return correct header size") {
                let headerSize = collectionProvider.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: 0)
                
                expect(headerSize) == CGSize(width: 0, height: kOptionCollectionViewHeaderHeight)
            }
            
            it("should return correct cell size") {
                let indexPath = IndexPath(item: 0, section: 0)
                let cellSize = collectionProvider.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
                
                expect(cellSize) == CGSize(width: collectionView.frame.width, height: kOptionCollectionViewCellHeight)
            }
        }
        
        describe("when data did set") {
            var option: ProductOption!
            var options: [ProductOption]!
            
            beforeEach {
                option = ProductOption()
                option.id = "Option id"
                
                let selectedOption = SelectedOption(name: "Name", value: "Value")
                collectionProvider.selectedOptions = [selectedOption]
            }
            
            context("if product option hasn't values") {
                beforeEach {
                    options = [option]
                    collectionProvider.options = options
                }
                
                it("should have correct sections count") {
                    let sectionsCount = collectionProvider.numberOfSections(in: collectionView)
                    
                    expect(sectionsCount) == options.count
                }
                
                it("should return correct items count") {
                    let itemsCount = collectionProvider.collectionView(collectionView, numberOfItemsInSection: 0)
                    
                    expect(itemsCount) == 0
                }
            }
            
            context("if product option has single value") {
                beforeEach {
                    option.values = ["Option value"]
                    options = [option]
                    collectionProvider.options = options
                }
                
                it("should have correct sections count") {
                    let sectionsCount = collectionProvider.numberOfSections(in: collectionView)
                    
                    expect(sectionsCount) == options.count
                }
                
                it("should return correct items count") {
                    let itemsCount = collectionProvider.collectionView(collectionView, numberOfItemsInSection: 0)
                    
                    expect(itemsCount) == 0
                }
                
                it("should have correct header class type") {
                    _ = collectionView.numberOfSections
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    let headerView = collectionProvider.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
                    
                    expect(headerView).to(beAnInstanceOf(ProductOptionHeaderView.self))
                }
            }
            
            context("if product option has multiple values") {
                beforeEach {
                    option.name = "Option name"
                    option.values = ["Option value 1", "Option value 2"]
                    options = [option]
                    collectionProvider.options = options
                }
                
                it("should have correct sections count") {
                    let sectionsCount = collectionProvider.numberOfSections(in: collectionView)
                    
                    expect(sectionsCount) == options.count
                }
                
                it("should return correct items count") {
                    let itemsCount = collectionProvider.collectionView(collectionView, numberOfItemsInSection: 0)
                    
                    expect(itemsCount) == 1
                }
                
                it("should have correct cell class type") {
                    let indexPath = IndexPath(row: 0, section: 0)
                    let cell = collectionProvider.collectionView(collectionView, cellForItemAt: indexPath)
                    
                    expect(cell).to(beAnInstanceOf(ProductOptionsCollectionViewCell.self))
                }
            }
        }
    }
}
