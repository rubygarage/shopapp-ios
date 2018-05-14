//
//  YearExpiryDatePickerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/4/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class YearExpiryDatePickerSpec: QuickSpec {
    override func spec() {
        var picker: YearExpiryDatePicker!
        
        beforeEach {
            picker = YearExpiryDatePicker()
        }
        
        describe("when picker initialized") {
            it("should have correct initial placeholder") {
                expect(picker.initialPlaceholder) == "Placeholder.Year".localizable
            }
            
            it("should have correct data") {
                let currentYear = Calendar.current.component(.year, from: Date())
                var years: [String] = []
                for index in 0..<30 {
                    years.append(String(currentYear + index))
                }
                
                expect(picker.data).to(equal(years))
            }
        }
    }
}
