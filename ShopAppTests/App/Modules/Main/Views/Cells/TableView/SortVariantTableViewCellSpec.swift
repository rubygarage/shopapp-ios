//
//  SortVariantTableViewCellSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class SortVariantTableViewCellSpec: QuickSpec {
    override func spec() {
        var cell: SortVariantTableViewCell!
        var variantTitleLabel: UILabel!
        var checkImageView: UIImageView!
        
        beforeEach {
            let provider = SortVariantsTableProvider()
            let tableView = UITableView()
            tableView.dataSource = provider
            tableView.delegate = provider
            tableView.registerNibForCell(SortVariantTableViewCell.self)
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: SortVariantTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            variantTitleLabel = self.findView(withAccessibilityLabel: "title", in: cell) as! UILabel
            checkImageView = self.findView(withAccessibilityLabel: "image", in: cell) as! UIImageView
        }
        
        describe("when cell initialized") {
            it("should have correct selection style") {
                expect(cell.selectionStyle.rawValue) == UITableViewCellSelectionStyle.none.rawValue
            }
        }
        
        describe("when cell configured") {
            beforeEach {
                cell.configure(with: "Title", selected: false)
            }
            
            it("needs to setup title label") {
                expect(variantTitleLabel.text) == "Title"
            }
            
            it("needs to setup check image view") {
                checkImageView.isHidden = true
            }
        }
    }
}
