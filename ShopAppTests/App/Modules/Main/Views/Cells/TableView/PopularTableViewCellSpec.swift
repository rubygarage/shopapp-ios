//
//  PopularTableViewCellSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class PopularTableViewCellSpec: QuickSpec {
    override func spec() {
        var cell: PopularTableViewCell!
        var collectionView: UICollectionView!
        var collectionViewHeightConstraint: NSLayoutConstraint!
        
        beforeEach {
            let provider = HomeTableProvider()
            let tableView = UITableView()
            tableView.registerNibForCell(PopularTableViewCell.self)
            tableView.dataSource = provider
            tableView.delegate = provider
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: PopularTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            collectionView = self.findView(withAccessibilityLabel: "collectionView", in: cell) as? UICollectionView
            collectionViewHeightConstraint = collectionView.constraints.filter({ $0.accessibilityLabel == "collectionViewHeightConstraint" }).first
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
            var products: [Product] = []
            
            context("if data has 1 item") {
                beforeEach {
                    products.append(Product())
                    cell.configure(with: products)
                }
                
                it("should have correct rows count") {
                    expect(collectionView.numberOfItems(inSection: 0)) == products.count
                }
                
                it("should have zero height collection view height") {
                    expect(collectionViewHeightConstraint.constant) == GridCollectionViewCell.cellSize.height
                }
            }
            
            context("if data has few items") {
                beforeEach {
                    for _ in 1...4 {
                        products.append(Product())
                    }
                    cell.configure(with: products)
                }
                
                it("should have correct rows count") {
                    expect(collectionView.numberOfItems(inSection: 0)) == products.count
                }
                
                it("should have zero height collection view height") {
                    expect(collectionViewHeightConstraint.constant) == 2 * GridCollectionViewCell.cellSize.height
                }
            }
            
        }
        
        describe("when collection item did select") {
            let product = Product()
            
            beforeEach {
                cell.configure(with: [product])
            }
            
            it("should select product") {
                let delegateMock = PopularTableCellDelegateMock()
                cell.delegate = delegateMock
                let indexPath = IndexPath(row: 0, section: 0)
                collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
                
                expect(delegateMock.tableViewCell) === cell
                expect(delegateMock.product) === product
            }
        }
    }
}
