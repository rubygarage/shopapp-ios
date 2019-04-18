//
//  PaymentTypeViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/8/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class PaymentTypeViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: PaymentTypeViewController!
        var tableProvider: PaymentTypeProvider!
        var selectedPaymentType: PaymentType!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.checkout, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.paymentType) as? PaymentTypeViewController
            
            tableProvider = PaymentTypeProvider()
            viewController.tableProvider = tableProvider
            
            selectedPaymentType = .applePay
            viewController.selectedType = selectedPaymentType
            
            _ = viewController.view
        }
        
        describe("when view loaded") {
            it("should have a correct title") {
                expect(viewController.title) == "ControllerTitle.PaymentType".localizable
            }
            
            it("should pass properties to table provider") {
                expect(tableProvider.selectedPaymentType) == viewController.selectedType
            }
            
            it("should have a correct table provider's delegate") {
                expect(tableProvider.delegate) === viewController
            }
            
            it("should have correct data source and delegate of table view") {
                expect(viewController.tableView.dataSource) === tableProvider
                expect(viewController.tableView.delegate) === tableProvider
            }
            
            it("should have correct content inset of table view") {
                expect(viewController.tableView.contentInset) == TableView.defaultContentInsets
            }
        }
        
        describe("when payment type did select") {
            it("should notify delegate, set updated type and reload table") {
                let delegateMock = PaymentTypeViewControllerDelegateMock()
                viewController.delegate = delegateMock
                
                viewController.provider(tableProvider, didSelect: .creditCard)
                
                expect(viewController.selectedType?.rawValue) == PaymentType.creditCard.rawValue
                expect(delegateMock.viewController) === viewController
                expect(delegateMock.paymentType?.rawValue) == PaymentType.creditCard.rawValue
            }
        }
    }
}

class PaymentTypeViewControllerTest: PaymentTypeViewController {
    let testTableView = UITableView()
    
    override weak var tableView: UITableView! {
        return testTableView
    }
}
