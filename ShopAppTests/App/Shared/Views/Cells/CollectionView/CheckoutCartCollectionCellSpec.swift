//
//  CheckoutCartCollectionCellSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CheckoutCartCollectionCellSpec: QuickSpec {
    override func spec() {
        var cell: CheckoutCartCollectionCell!
        var collectionView: UICollectionView!
        var cartItemImageView: UIImageView!
        
        beforeEach {
            let collectionProvider = CheckoutCartCollectionProvider()
            
            collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
            collectionView.registerNibForCell(CheckoutCartCollectionCell.self)
            
            collectionView.dataSource = collectionProvider
            collectionView.delegate = collectionProvider
            
            collectionProvider.images = [Image(), Image()]
            collectionProvider.productVariantIds = ["firstId", "secondId"]
            collectionView.reloadData()
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: CheckoutCartCollectionCell = collectionView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            cartItemImageView = self.findView(withAccessibilityLabel: "image", in: cell) as! UIImageView
        }
        
        describe("when cell configured") {
            var productVariantId: String!
            
            beforeEach {
                productVariantId = "id"
                
                cell.configure(with: Image(), productVariantId: productVariantId)
            }
            
            it("needs to setup image to image view") {
                expect(cartItemImageView.image).toNot(beNil())
            }
            
            it("needs to setup product variant id to cell") {
                expect(cell.productVariantId) == productVariantId
            }
        }
    }
}
