//
//  AccountLoggedHeaderViewSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/6/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import AvatarImageView
import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class AccountLoggedHeaderViewSpec: QuickSpec {
    override func spec() {
        var view: AccountLoggedHeaderView!
        var delegateMock: AccountLoggedHeaderDelegateMock!
        var myOrdersButton: UIButton!
        var personalInfoButton: UIButton!
        var welcomeLabel: UILabel!
        var customerNameLabel: UILabel!
        var shippingAddressButton: UIButton!
        var customerImageView: AvatarImageView!
        
        beforeEach {
            let customer = Customer()
            customer.firstName = "First"
            customer.lastName = "Last"
            
            view = AccountLoggedHeaderView(frame: CGRect.zero, customer: customer)
            
            myOrdersButton = self.findView(withAccessibilityLabel: "myOrders", in: view) as! UIButton
            personalInfoButton = self.findView(withAccessibilityLabel: "perosnalInfo", in: view) as! UIButton
            welcomeLabel = self.findView(withAccessibilityLabel: "welcome", in: view) as! UILabel
            customerNameLabel = self.findView(withAccessibilityLabel: "customerName", in: view) as! UILabel
            shippingAddressButton = self.findView(withAccessibilityLabel: "shippingAddress", in: view) as! UIButton
            customerImageView = self.findView(withAccessibilityLabel: "customerImage", in: view) as! AvatarImageView
        }
        
        describe("when view initialized") {
            it("should have correct buttons titles") {
                expect(myOrdersButton.title(for: .normal)) == "Button.MyOrders".localizable
                expect(personalInfoButton.title(for: .normal)) == "Button.PersonalInfo".localizable
                expect(shippingAddressButton.title(for: .normal)) == "Button.ShippingAddress".localizable
            }
            
            it("should have correct welcome label text") {
                expect(welcomeLabel.text) == "Label.Welcome".localizable
            }
            
            it("should have correct customer name label text") {
                expect(customerNameLabel.text) == "First Last"
            }
            
            it("should have correct customer image configuration") {
                expect(customerImageView.configuration.bgColor) == .black
                expect(customerImageView.configuration.textSizeFactor) == 0.4
            }
            
            it("should have correct customer image data source") {
                expect(customerImageView.dataSource?.name) == "First Last"
            }
        }
        
        describe("when my orders button pressed") {
            it("needs to show sign in screen") {
                delegateMock = AccountLoggedHeaderDelegateMock()
                view.delegate = delegateMock
                myOrdersButton.sendActions(for: .touchUpInside)
                
                expect(delegateMock.isMyOrdersTapped) == true
                expect(delegateMock.headerView) === view
            }
        }
        
        describe("when personal info button pressed") {
            it("needs to show sign in screen") {
                delegateMock = AccountLoggedHeaderDelegateMock()
                view.delegate = delegateMock
                personalInfoButton.sendActions(for: .touchUpInside)
                
                expect(delegateMock.isPersonalInfoTapped) == true
                expect(delegateMock.headerView) === view
            }
        }
        
        describe("when shipping address button pressed") {
            it("needs to show sign in screen") {
                delegateMock = AccountLoggedHeaderDelegateMock()
                view.delegate = delegateMock
                shippingAddressButton.sendActions(for: .touchUpInside)
                
                expect(delegateMock.isShippingAddressTapped) == true
                expect(delegateMock.headerView) === view
            }
        }
    }
}
