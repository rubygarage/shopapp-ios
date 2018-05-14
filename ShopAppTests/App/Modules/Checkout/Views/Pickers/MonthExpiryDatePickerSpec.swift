//
//  MonthExpiryDatePickerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/4/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class MonthExpiryDatePickerSpec: QuickSpec {
    override func spec() {
        var picker: MonthExpiryDatePicker!
        
        beforeEach {
            picker = MonthExpiryDatePicker()
        }
        
        describe("when picker initialized") {
            it("should have correct initial placeholder") {
                expect(picker.initialPlaceholder) == "Placeholder.Month".localizable
            }
            
            it("should have correct data") {
                var monthes: [String] = []
                for index in 1...Calendar.current.monthSymbols.count {
                    monthes.append(String(format: "%02d", index))
                }
                
                expect(picker.data).to(equal(monthes))
            }
        }
    }
}
