//
//  AddressListTableHeaderViewSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/4/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class AddressListTableHeaderViewSpec: QuickSpec {
    override func spec() {
        var header: AddressListTableHeaderView!
        var addNewAddressButton: BlackButton!
        
        beforeEach {
            header = AddressListTableHeaderView(frame: CGRect.zero)
            addNewAddressButton = self.findView(withAccessibilityLabel: "addNewAddressButton", in: header) as? BlackButton
        }
        
        describe("when header initialized") {
            it("should have correct add new address button title") {
                expect(addNewAddressButton.title(for: .normal)) == "Button.AddNewAddress".localizable.uppercased()
            }
        }
        
        describe("when add new address did press") {
            it("should notify delegate") {
                let delegateMock = AddressListHeaderViewDelegateMock()
                header.delegate = delegateMock
                
                addNewAddressButton.sendActions(for: .touchUpInside)
                
                expect(delegateMock.header) === header
            }
        }
    }
}
