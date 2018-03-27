//
//  DetailsImagesCollectionViewCellSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class DetailsImagesCollectionViewCellSpec: QuickSpec {
    override func spec() {
        var cell: DetailsImagesCollectionViewCell!
        var productImageView: UIImageView!
        
        beforeEach {
            let provider = ImagesCarouselCollectionProvider()
            let collectionViewLayout = UICollectionViewLayout()
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
            collectionView.dataSource = provider
            collectionView.registerNibForCell(DetailsImagesCollectionViewCell.self)
            
            provider.images = [Image()]
            collectionView.reloadData()
            
            let indexPath = IndexPath(item: 0, section: 0)
            let dequeuedCell: DetailsImagesCollectionViewCell = collectionView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            productImageView = self.findView(withAccessibilityLabel: "productImageView", in: cell) as! UIImageView
        }
        
        describe("when cell configured") {
            var image: Image!
            
            beforeEach {
                image = Image()
                image.src = "https://via.placeholder.com/100x100"
            }
            
            it("needs to set image") {
                cell.configure(with: image)
                
                expect(productImageView.image).toNot(beNil())
            }
        }
    }
}
