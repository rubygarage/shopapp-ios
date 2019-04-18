//
//  OrderFooterViewMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class OrderFooterViewMock: QuickSpec {
    override func spec() {
        var view: OrderFooterView!
        var delegateMock: OrderFooterDelegateMock!
        var itemsLabel: UILabel!
        var countLabel: UILabel!
        var totalLabel: UILabel!
        var priceLabel: UILabel!
        
        beforeEach {
            let firstOrderItem = OrderItem()
            firstOrderItem.quantity = 1
            
            let secondOrderItem = OrderItem()
            secondOrderItem.quantity = 2
            
            let order = Order()
            order.currencyCode = "UAH"
            order.totalPrice = 29.99
            order.items = [firstOrderItem, secondOrderItem]
            
            view = OrderFooterView(section: 0, order: order)
            
            itemsLabel = self.findView(withAccessibilityLabel: "items", in: view) as? UILabel
            countLabel = self.findView(withAccessibilityLabel: "count", in: view) as? UILabel
            totalLabel = self.findView(withAccessibilityLabel: "total", in: view) as? UILabel
            priceLabel = self.findView(withAccessibilityLabel: "price", in: view) as? UILabel
        }
        
        describe("when view initialized") {
            it("should have correct items label text") {
                expect(itemsLabel.text) == "Label.Order.Items".localizable
            }
            
            it("should have correct total label text") {
                expect(totalLabel.text) == "Label.Order.TotalWithColon".localizable.uppercased()
            }
            
            it("should have tap gesture recognizer") {
                expect(view.gestureRecognizers?.isEmpty) == false
            }
            
            it("should have correct count label text") {
                expect(countLabel.text) == "3"
            }
            
            it("should have correct price label text") {
                expect(priceLabel.text) == "UAH29.99"
            }
        }
        
        describe("when view tapped") {
            it("needs to open order details") {
                delegateMock = OrderFooterDelegateMock()
                view.delegate = delegateMock
                
                let tap = view.gestureRecognizers!.first!
                view.viewDidTap(gestureRecognizer: tap)
                
                expect(delegateMock.footerView) === view
                expect(delegateMock.section) == 0
            }
        }
    }
}
