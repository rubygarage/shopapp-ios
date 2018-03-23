//
//  CategoryCollectionViewCellSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CategoryCollectionViewCellSpec: QuickSpec {
    override func spec() {
        var cell: CategoryCollectionViewCell!
        var categoryTitleLabel: UILabel!
        var categoryImageView: UIImageView!
        
        beforeEach {
            let provider = CategoryListCollectionProvider()
            let collectionViewLayout = UICollectionViewLayout()
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
            collectionView.dataSource = provider
            collectionView.delegate = provider
            collectionView.registerNibForCell(CategoryCollectionViewCell.self)
            
            provider.categories = [Category()]
            collectionView.reloadData()
            
            let indexPath = IndexPath(item: 0, section: 0)
            let dequeuedCell: CategoryCollectionViewCell = collectionView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            categoryTitleLabel = self.findView(withAccessibilityLabel: "title", in: cell) as! UILabel
            categoryImageView = self.findView(withAccessibilityLabel: "image", in: cell) as! UIImageView
        }
        
        it("should have correct class variables") {
            let screenWidth = UIScreen.main.bounds.size.width
            let cellWidth = screenWidth / 2 - 4
            let cellHeight = CGFloat(lroundf(Float(cellWidth * 140 / 169)))
            
            expect(CategoryCollectionViewCell.cellSize) == CGSize(width: cellWidth, height: cellHeight)
            expect(CategoryCollectionViewCell.collectionViewInsets) == UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        }
        
        describe("when cell configured") {
            it("needs to setup title and image") {
                let category = Category()
                category.title = "Title"
                category.image = Image()
                cell.configure(with: category)
                
                expect(categoryTitleLabel.text) == category.title
                expect(categoryImageView.image).toNot(beNil())
            }
        }
    }
}
