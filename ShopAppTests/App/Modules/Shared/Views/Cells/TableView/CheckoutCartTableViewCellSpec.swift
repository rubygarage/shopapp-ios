//
//  CheckoutCartTableViewCellSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CheckoutCartTableViewCellSpec: QuickSpec {
    override func spec() {
        var cell: CheckoutCartTableViewCell!
        var collectionView: UICollectionView!
        
        beforeEach {
            let provider = OrderListTableProvider()
            let tableView = UITableView()
            tableView.dataSource = provider
            tableView.delegate = provider
            tableView.registerNibForCell(CheckoutCartTableViewCell.self)
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: CheckoutCartTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            collectionView = self.findView(withAccessibilityLabel: "collectionView", in: cell) as! UICollectionView
        }
        
        describe("when cell initialized") {
            it("should have correct selection style") {
                expect(cell.selectionStyle.rawValue) == UITableViewCellSelectionStyle.none.rawValue
            }
            
            it("should have correct number of items in collection view") {
                expect(collectionView.numberOfItems(inSection: 0)) == 0
            }
        }
        
        describe("when cell configured") {
            it("should have correct number of items in collection view") {
                let images = [Image(), Image()]
                let ids = ["firstId", "secondId"]
                let index = 1
                cell.configure(with: images, productVariantIds: ids, index: index)
                
                expect(collectionView.numberOfItems(inSection: 0)) == images.count
            }
        }
        
        describe("when collection view's item selected") {
            it("needs to notify delegate") {
                let images = [Image(), Image()]
                let ids = ["firstId", "secondId"]
                let index = 1
                cell.configure(with: images, productVariantIds: ids, index: index)
                
                let delegateMock = CheckoutCartTableViewCellDelegateMock()
                cell.delegate = delegateMock
                cell.provider(CheckoutCartCollectionProvider(), didSelectItemWith: ids.last!)
                
                expect(delegateMock.cell) === cell
                expect(delegateMock.productVariantId) == ids.last!
                expect(delegateMock.index) == index
            }
        }
    }
}
