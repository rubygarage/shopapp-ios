//
//  SearchEmptyDataViewSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/15/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class SearchEmptyDataViewSpec: QuickSpec {
    override func spec() {
        var view: SearchEmptyDataView!
        var emptySearchLabel: UILabel!
        
        beforeEach {
            view = SearchEmptyDataView()
            
            emptySearchLabel = self.findView(withAccessibilityLabel: "emptySearch", in: view) as? UILabel
        }
        
        describe("when view initialized") {
            it("should have correct label text") {
                expect(emptySearchLabel.text) == "Label.NoResultFound".localizable
            }
        }
    }
}
