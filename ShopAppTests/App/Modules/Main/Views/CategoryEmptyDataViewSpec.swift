//
//  CategoryEmptyDataViewSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CategoryEmptyDataViewSpec: QuickSpec {
    override func spec() {
        var view: CategoryEmptyDataView!
        var emptyCategoryLabel: UILabel!
        
        beforeEach {
            view = CategoryEmptyDataView()
            
            emptyCategoryLabel = self.findView(withAccessibilityLabel: "emptyCategory", in: view) as? UILabel
        }
        
        describe("when view initialized") {
            it("should have correct label text") {
                expect(emptyCategoryLabel.text) == "Label.NoProductYet".localizable
            }
        }
    }
}
