//
//  OrderHeaderViewSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class OrderHeaderViewSpec: QuickSpec {
    override func spec() {
        var view: OrderHeaderView!
        var delegateMock: OrderHeaderDelegateMock!
        var numberLabel: UILabel!
        var dateLabel: UILabel!
        
        beforeEach {
            let dateString = "2018-03-02"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatter.date(from: dateString)
            let order = Order()
            order.number = 1
            order.createdAt = date
            
            view = OrderHeaderView(section: 0, order: order)
            
            numberLabel = self.findView(withAccessibilityLabel: "number", in: view) as! UILabel
            dateLabel = self.findView(withAccessibilityLabel: "date", in: view) as! UILabel
        }
        
        describe("when view initialized") {
            it("should have tap gesture recognizer") {
                expect(view.gestureRecognizers?.isEmpty) == false
            }
            
            it("should have correct number label text") {
                let numberFormat = "Label.Order.Number".localizable.uppercased()
                
                expect(numberLabel.text) == String(format: numberFormat, "1")
            }
            
            it("should have correct date label text") {
                let dateFormat = "Label.Order.Date".localizable
                
                expect(dateLabel.text) == String(format: dateFormat, "Friday, Mar 2, 2018")
            }
        }
        
        describe("when view tapped") {
            it("needs to open order details") {
                delegateMock = OrderHeaderDelegateMock()
                view.delegate = delegateMock
                
                let tap = view.gestureRecognizers!.first!
                view.viewDidTap(gestureRecognizer: tap)
                
                expect(delegateMock.headerView) === view
                expect(delegateMock.section) == 0
            }
        }
    }
}
