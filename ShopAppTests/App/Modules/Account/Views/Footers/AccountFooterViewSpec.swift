//
//  AccountFooterViewSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/6/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class AccountFooterViewSpec: QuickSpec {
    override func spec() {
        var view: AccountFooterView!
        var delegateMock: AccountFooterDelegateMock!
        var logoutButton: UnderlinedButton!
        var logoutUnderlineView: UIView!
        
        beforeEach {
            let provider = AccountTableProvider()
            let tableView = UITableView()
            tableView.dataSource = provider
            tableView.delegate = provider
            tableView.registerNibForHeaderFooterView(AccountFooterView.self)
            
            let dequeuedView: AccountFooterView = tableView.dequeueReusableHeaderFooterView()
            view = dequeuedView
            
            logoutButton = self.findView(withAccessibilityLabel: "logout", in: view) as! UnderlinedButton
            logoutUnderlineView = self.findView(withAccessibilityLabel: "underline", in: view)
        }
        
        describe("when view initialized") {
            it("should have correct logout button title") {
                expect(logoutButton.title(for: .normal)) == "Button.Logout".localizable.uppercased()
            }
            
            it("should have logout button delegate") {
                expect(logoutButton.delegate) === view
            }
        }
        
        describe("when logout button pressed") {
            it("needs to hide underline view on highlighted state") {
                logoutButton.isHighlighted = true
                
                expect(logoutUnderlineView.isHidden) == true
            }
            
            it("needs to show underline view on normal state") {
                logoutButton.isHighlighted = false
                
                expect(logoutUnderlineView.isHidden) == false
            }
            
            it("needs to logout") {
                delegateMock = AccountFooterDelegateMock()
                view.delegate = delegateMock
                logoutButton.sendActions(for: .touchUpInside)
                
                expect(delegateMock.footerView) === view
            }
        }
    }
}
