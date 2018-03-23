//
//  LastArrivalsTableViewCellSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class LastArrivalsTableViewCellSpec: QuickSpec {
    override func spec() {
        var cell: LastArrivalsTableViewCell!
        var collectionView: UICollectionView!
        
        beforeEach {
            let provider = HomeTableProvider()
            let tableView = UITableView()
            tableView.registerNibForCell(LastArrivalsTableViewCell.self)
            tableView.dataSource = provider
            tableView.delegate = provider
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: LastArrivalsTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            collectionView = self.findView(withAccessibilityLabel: "collectionView", in: cell) as! UICollectionView
        }
        
        describe("when cell initialized") {
            it("should have correct superclass") {
                expect(cell).to(beAKindOf(UITableViewCell.self))
            }
            
            it("should have correct rows count") {
                expect(collectionView.numberOfItems(inSection: 0)) == 0
            }
        }
        
        describe("when cell configured") {
            var products: [Product]!
            
            beforeEach {
                products = [Product()]
                cell.configure(with: products)
            }
            
            it("should have correct rows count") {
                expect(collectionView.numberOfItems(inSection: 0)) == products.count
            }
        }
        
        describe("when collection item did select") {
            let product = Product()
            
            beforeEach {
                cell.configure(with: [product])
            }
            
            it("should select product") {
                let delegateMock = LastArrivalsTableCellDelegateMock()
                cell.delegate = delegateMock
                let indexPath = IndexPath(row: 0, section: 0)
                collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
                
                expect(delegateMock.tableViewCell) === cell
                expect(delegateMock.product) === product
            }
        }
    }
}
