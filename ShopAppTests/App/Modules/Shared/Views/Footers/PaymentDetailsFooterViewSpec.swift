//
//  PaymentDetailsFooterViewSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class PaymentDetailsFooterViewSpec: QuickSpec {
    override func spec() {
        var view: PaymentDetailsFooterView!
        var subtotalLabel: UILabel!
        var discountLabel: UILabel!
        var shippingLabel: UILabel!
        var totalLabel: UILabel!
        var subtotalValueLabel: UILabel!
        var discountValueLabel: UILabel!
        var shippingValueLabel: UILabel!
        var totalValueLabel: UILabel!

        func setupViews() {
            subtotalLabel = self.findView(withAccessibilityLabel: "subtotal", in: view) as! UILabel
            discountLabel = self.findView(withAccessibilityLabel: "discount", in: view) as! UILabel
            shippingLabel = self.findView(withAccessibilityLabel: "shipping", in: view) as! UILabel
            totalLabel = self.findView(withAccessibilityLabel: "total", in: view) as! UILabel
            subtotalValueLabel = self.findView(withAccessibilityLabel: "subtotalValue", in: view) as! UILabel
            discountValueLabel = self.findView(withAccessibilityLabel: "discountValue", in: view) as! UILabel
            shippingValueLabel = self.findView(withAccessibilityLabel: "shippingValue", in: view) as! UILabel
            totalValueLabel = self.findView(withAccessibilityLabel: "totalValue", in: view) as! UILabel
        }
        
        describe("when view initialized") {
            it("should have label with corrext texts") {
                view = PaymentDetailsFooterView(order: TestHelper.orderWithProducts)
                setupViews()
                
                expect(subtotalLabel.text) == "Label.Order.Subtotal".localizable
                expect(discountLabel.text) == "Label.Order.Discount".localizable
                expect(shippingLabel.text) == "Label.Order.Shipping".localizable
                expect(totalLabel.text) == "Label.Order.Total".localizable.uppercased()
            }
            
            context("if view was init with order") {
                it("needs to setup value labels with order's data") {
                    let order = TestHelper.orderWithProducts
                    view = PaymentDetailsFooterView(order: order)
                    setupViews()
                    
                    let formatter = NumberFormatter.formatter(with: order.currencyCode)
                    let subtotalPrice = NSDecimalNumber(decimal: order.subtotalPrice!)
                    let discountPrice = NSDecimalNumber(value: 0)
                    let totalShippingPrice = NSDecimalNumber(decimal: order.totalShippingPrice!)
                    let totalPrice = NSDecimalNumber(decimal: order.totalPrice)
                    
                    expect(subtotalValueLabel.text) == formatter.string(from: subtotalPrice)
                    expect(discountValueLabel.text) == formatter.string(from: discountPrice)
                    expect(shippingValueLabel.text) == formatter.string(from: totalShippingPrice)
                    expect(totalValueLabel.text) == formatter.string(from: totalPrice)
                }
            }
            
            context("if view was init with checkout") {
                it("needs to setup value labels with checkout's data") {
                    let checkout = TestHelper.checkoutWithShippingAddress
                    view = PaymentDetailsFooterView(checkout: checkout)
                    setupViews()
                    
                    let formatter = NumberFormatter.formatter(with: checkout.currency)
                    let subtotalPrice = NSDecimalNumber(decimal: checkout.subtotalPrice)
                    let discountPrice = NSDecimalNumber(value: 0)
                    let totalShippingPrice = NSDecimalNumber(decimal: checkout.shippingRate!.price)
                    let totalPrice = NSDecimalNumber(decimal: checkout.totalPrice)
                    
                    expect(subtotalValueLabel.text) == formatter.string(from: subtotalPrice)
                    expect(discountValueLabel.text) == formatter.string(from: discountPrice)
                    expect(shippingValueLabel.text) == formatter.string(from: totalShippingPrice)
                    expect(totalValueLabel.text) == formatter.string(from: totalPrice)
                }
            }
        }
    }
}
