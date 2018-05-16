//
//  CheckoutTableProviderSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CheckoutTableProviderSpec: QuickSpec {
    override func spec() {
        var tableProvider: CheckoutTableProvider!
        var tableView: UITableView!
        
        beforeEach {
            tableProvider = CheckoutTableProvider()
            
            tableView = UITableView()
            tableView.registerNibForCell(CheckoutCartTableViewCell.self)
            tableView.registerNibForCell(CheckoutShippingAddressAddTableViewCell.self)
            tableView.registerNibForCell(CheckoutShippingAddressEditTableCell.self)
            tableView.registerNibForCell(CheckoutPaymentAddTableViewCell.self)
            tableView.registerNibForCell(CheckoutSelectedTypeTableViewCell.self)
            tableView.registerNibForCell(CheckoutCreditCardEditTableViewCell.self)
            tableView.registerNibForCell(CheckoutBillingAddressEditTableViewCell.self)
            tableView.registerNibForCell(CheckoutShippingOptionsDisabledTableViewCell.self)
            tableView.registerNibForCell(CheckoutShippingOptionsEnabledTableViewCell.self)
            tableView.registerNibForCell(CustomerEmailTableViewCell.self)
            
            tableView.dataSource = tableProvider
            tableView.delegate = tableProvider
        }
        
        describe("when get sections count called") {
            context("if selected payment type is credit card") {
                it("should return a correct sections count") {
                    tableProvider.selectedPaymentType = .creditCard
                    
                    expect(tableProvider.numberOfSections(in: tableView)) == CheckoutSection.allValues.count
                }
            }
            
            context("if selected payment type is apple pay") {
                it("should return a correct sections count") {
                    tableProvider.selectedPaymentType = .applePay
                    
                    expect(tableProvider.numberOfSections(in: tableView)) == CheckoutSection.valuesWithoutShippingOptions.count
                }
            }
        }
        
        describe("when get rows count called") {
            context("if section is customer email") {
                context("and customer has email") {
                    it("should return a correct rows count") {
                        tableProvider.customerHasEmail = true
                        
                        let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: CheckoutSection.customerEmail.rawValue)
                        expect(rowsCount) == 0
                    }
                }
                
                context("and customer hasn't email") {
                    it("should return a correct rows count") {
                        tableProvider.customerHasEmail = false
                        
                        let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: CheckoutSection.customerEmail.rawValue)
                        expect(rowsCount) == 1
                    }
                }
            }
            
            context("if section is shipping options") {
                var checkout: Checkout!
                
                beforeEach {
                    checkout = Checkout()
                }
                
                context("and checkout has available shipping rates") {
                    it("should return a correct rows count") {
                        let shippingRate = ShippingRate()
                        let availableShipingRates = [shippingRate, shippingRate]
                        checkout.availableShippingRates = availableShipingRates
                        tableProvider.checkout = checkout
                        
                        let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: CheckoutSection.shippingOptions.rawValue)
                        expect(rowsCount) == availableShipingRates.count
                    }
                }
                
                context("and checkout hasn't available shipping rates") {
                    it("should return a correct rows count") {
                        tableProvider.checkout = checkout
                        
                        let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: CheckoutSection.shippingOptions.rawValue)
                        expect(rowsCount) == 1
                    }
                }
                
                context("and checkout is nil") {
                    it("should return a correct rows count") {
                        let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: CheckoutSection.shippingOptions.rawValue)
                        expect(rowsCount) == 1
                    }
                }
            }
            
            context("if section is payment") {
                context("and payment type is credit card") {
                    it("should return a correct rows count") {
                        tableProvider.selectedPaymentType = .creditCard
                        
                        let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: CheckoutSection.payment.rawValue)
                        expect(rowsCount) == PaymentAddCellType.allValues.count
                    }
                }
                
                context("and payment type is apple pay") {
                    it("should return a correct rows count") {
                        tableProvider.selectedPaymentType = .applePay
                        
                        let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: CheckoutSection.payment.rawValue)
                        expect(rowsCount) == 1
                    }
                }
            }
            
            context("if section is cart") {
                it("should return a correct rows count") {
                    let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: CheckoutSection.cart.rawValue)
                    expect(rowsCount) == 1
                }
            }
        }
        
        describe("when cell for index path called") {
            context("if section is cart") {
                it("should return correct cell type") {
                    let indexPath = IndexPath(row: 0, section: CheckoutSection.cart.rawValue)
                    
                    let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                    expect(cell).to(beAnInstanceOf(CheckoutCartTableViewCell.self))
                }
            }
            
            context("if section is customerEmail") {
                it("should return correct cell type") {
                    let indexPath = IndexPath(row: 0, section: CheckoutSection.customerEmail.rawValue)
                    
                    let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                    expect(cell).to(beAnInstanceOf(CustomerEmailTableViewCell.self))
                }
            }
            
            context("if section is shipping address") {
                var checkout: Checkout!
                
                beforeEach {
                    checkout = Checkout()
                }
                
                context("and checkout has shipping address") {
                    it("should return correct cell type") {
                        let shippingAddress = Address()
                        shippingAddress.address = "Address"
                        checkout.shippingAddress = shippingAddress
                        tableProvider.checkout = checkout
                        
                        let indexPath = IndexPath(row: 0, section: CheckoutSection.shippingAddress.rawValue)
                        
                        let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                        expect(cell).to(beAnInstanceOf(CheckoutShippingAddressEditTableCell.self))
                    }
                }
                
                context("or checkout hasn't shipping address") {
                    it("should return correct cell type") {
                        tableProvider.checkout = checkout
                        
                        let indexPath = IndexPath(row: 0, section: CheckoutSection.shippingAddress.rawValue)
                        
                        let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                        expect(cell).to(beAnInstanceOf(CheckoutShippingAddressAddTableViewCell.self))
                    }
                }
                
                context("or checkout is nil") {
                    it("should return correct cell type") {
                        let indexPath = IndexPath(row: 0, section: CheckoutSection.shippingAddress.rawValue)
                        
                        let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                        expect(cell).to(beAnInstanceOf(CheckoutShippingAddressAddTableViewCell.self))
                    }
                }
            }
            
            context("if section is payment") {
                context("and row is 'type'") {
                    context("and selected payment type exist") {
                        it("should return correct cell type") {
                            tableProvider.selectedPaymentType = .creditCard
                            
                            let indexPath = IndexPath(row: PaymentAddCellType.type.rawValue, section: CheckoutSection.payment.rawValue)
                            
                            let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                            expect(cell).to(beAnInstanceOf(CheckoutSelectedTypeTableViewCell.self))
                        }
                    }
                    
                    context("or selected payment type doesn't exist") {
                        it("should return correct cell type") {
                            let indexPath = IndexPath(row: PaymentAddCellType.type.rawValue, section: CheckoutSection.payment.rawValue)
                            
                            let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                            expect(cell).to(beAnInstanceOf(CheckoutPaymentAddTableViewCell.self))
                        }
                    }
                }
                
                context("and row is 'card'") {
                    context("and credit card exist") {
                        it("should return correct cell type") {
                            tableProvider.creditCard = CreditCard()
                            
                            let indexPath = IndexPath(row: PaymentAddCellType.card.rawValue, section: CheckoutSection.payment.rawValue)
                            
                            let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                            expect(cell).to(beAnInstanceOf(CheckoutCreditCardEditTableViewCell.self))
                        }
                    }
                    
                    context("or credit card doesn't exist") {
                        it("should return correct cell type") {
                            let indexPath = IndexPath(row: PaymentAddCellType.card.rawValue, section: CheckoutSection.payment.rawValue)
                            
                            let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                            expect(cell).to(beAnInstanceOf(CheckoutPaymentAddTableViewCell.self))
                        }
                    }
                }
                
                context("if row is 'billingAddress'") {
                    context("and billing address exist") {
                        it("should return correct cell type") {
                            let billingAddress = Address()
                            billingAddress.address = "Address"
                            tableProvider.billingAddress = billingAddress
                            
                            let indexPath = IndexPath(row: PaymentAddCellType.billingAddress.rawValue, section: CheckoutSection.payment.rawValue)
                            
                            let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                            expect(cell).to(beAnInstanceOf(CheckoutBillingAddressEditTableViewCell.self))
                        }
                    }
                    
                    context("or billing address exist") {
                        it("should return correct cell type") {
                            let indexPath = IndexPath(row: PaymentAddCellType.billingAddress.rawValue, section: CheckoutSection.payment.rawValue)
                            
                            let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                            expect(cell).to(beAnInstanceOf(CheckoutPaymentAddTableViewCell.self))
                        }
                    }
                }
                
                context("if other row number") {
                    it("should return corect cell type") {
                        let row = PaymentAddCellType.allValues.count + 1
                        let indexPath = IndexPath(row: row, section: CheckoutSection.payment.rawValue)
                        
                        let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                        expect(cell).to(beAnInstanceOf(UITableViewCell.self))
                    }
                }
            }
            
            context("if section is shipping options") {
                context("and checkout has shipping address, available shipping rates and currency code") {
                    it("should return corect cell type") {
                        let checkout = Checkout()
                        checkout.shippingAddress = Address()
                        checkout.availableShippingRates = [ShippingRate()]
                        checkout.currencyCode = "USD"
                        tableProvider.checkout = checkout
                        
                        let indexPath = IndexPath(row: 0, section: CheckoutSection.shippingOptions.rawValue)
                        
                        let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                        expect(cell).to(beAnInstanceOf(CheckoutShippingOptionsEnabledTableViewCell.self))
                    }
                }
                
                context("or hasn't") {
                    it("should return corect cell type") {
                        let indexPath = IndexPath(row: 0, section: CheckoutSection.shippingOptions.rawValue)
                        
                        let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                        expect(cell).to(beAnInstanceOf(CheckoutShippingOptionsDisabledTableViewCell.self))
                    }
                }
            }
            
            context("if other section") {
                it("should return correct cell type") {
                    let section = CheckoutSection.allValues.count + 1
                    let indexPath = IndexPath(row: 0, section: section)
                    
                    let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                    
                    expect(cell).to(beAnInstanceOf(UITableViewCell.self))
                }
            }
        }
        
        describe("when height for header called") {
            context("if section is cart") {
                it("should return corrct header height") {
                    let headerHeight = tableProvider.tableView(tableView, heightForHeaderInSection: CheckoutSection.cart.rawValue)
                    expect(headerHeight) == kSeeAllTableHeaderViewHeight
                }
            }
            
            context("if section is customer email") {
                context("and customer has email") {
                    it("should return correct header height") {
                        tableProvider.customerHasEmail = true
                        
                        let headerHeight = tableProvider.tableView(tableView, heightForHeaderInSection: CheckoutSection.customerEmail.rawValue)
                        expect(headerHeight) == TableView.headerFooterMinHeight
                    }
                }
                
                context("or customer hasn't email") {
                    it("should return correct header height") {
                        tableProvider.customerHasEmail = false
                        
                        let headerHeight = tableProvider.tableView(tableView, heightForHeaderInSection: CheckoutSection.customerEmail.rawValue)
                        expect(headerHeight) == kBoldTitleTableHeaderViewHeight
                    }
                }
            }
            
            context("if other section") {
                it("should return correct header height") {
                    let section = CheckoutSection.allValues.count + 1
                    let headerHeight = tableProvider.tableView(tableView, heightForHeaderInSection: section)
                    expect(headerHeight) == kBoldTitleTableHeaderViewHeight
                }
            }
        }
        
        describe("when height for footer called") {
            context("if checkout exist and section is shipping options") {
                it("should return correct footer height") {
                    let checkout = Checkout()
                    tableProvider.checkout = checkout
                    
                    let section = CheckoutSection.shippingOptions.rawValue
                    let footerHeight = tableProvider.tableView(tableView, heightForFooterInSection: section)
                    expect(footerHeight) == kPaymentDetailsFooterViewHeight
                }
            }
            
            context("if checkout exist and section is shipping options") {
                it("should return correct footer height") {
                    let footerHeight = tableProvider.tableView(tableView, heightForFooterInSection: 0)
                    expect(footerHeight) == TableView.headerFooterMinHeight
                }
            }
        }
        
        describe("when view for header called") {
            context("if section is cart") {
                it("should return correct header view type") {
                    let headerView = tableProvider.tableView(tableView, viewForHeaderInSection: CheckoutSection.cart.rawValue)
                    expect(headerView).to(beAnInstanceOf(SeeAllTableHeaderView.self))
                }
            }
            
            context("if section is customer email") {
                context("and customer has email") {
                    it("should return correct header view type") {
                        tableProvider.customerHasEmail = true
                        
                        let headerView = tableProvider.tableView(tableView, viewForHeaderInSection: CheckoutSection.customerEmail.rawValue)
                        expect(headerView).to(beNil())
                    }
                }
                
                context("or customer has email") {
                    it("should return correct header view type") {
                        tableProvider.customerHasEmail = false
                        
                        let headerView = tableProvider.tableView(tableView, viewForHeaderInSection: CheckoutSection.customerEmail.rawValue)
                        expect(headerView).to(beAnInstanceOf(BoldTitleTableHeaderView.self))
                    }
                }
            }
            
            context("if section is shipping address") {
                it("should return correct header view type") {
                    let headerView = tableProvider.tableView(tableView, viewForHeaderInSection: CheckoutSection.shippingAddress.rawValue)
                    expect(headerView).to(beAnInstanceOf(BoldTitleTableHeaderView.self))
                }
            }
            
            context("if section is payment address") {
                it("should return correct header view type") {
                    let headerView = tableProvider.tableView(tableView, viewForHeaderInSection: CheckoutSection.payment.rawValue)
                    expect(headerView).to(beAnInstanceOf(BoldTitleTableHeaderView.self))
                }
            }
            
            context("if section is payment address") {
                it("should return correct header view type") {
                    let headerView = tableProvider.tableView(tableView, viewForHeaderInSection: CheckoutSection.shippingOptions.rawValue)
                    expect(headerView).to(beAnInstanceOf(BoldTitleTableHeaderView.self))
                }
            }
            
            context("if other section") {
                it("should return nil") {
                    let section = CheckoutSection.allValues.count + 1
                    let headerView = tableProvider.tableView(tableView, viewForHeaderInSection: section)
                    expect(headerView).to(beNil())
                }
            }
        }
        
        describe("when view for footer called") {
            context("if checkout exist and section is shipping options") {
                it("should return correct footer view type") {
                    let checkout = Checkout()
                    checkout.currencyCode = "USD"
                    checkout.subtotalPrice = 20
                    checkout.totalPrice = 22
                    tableProvider.checkout = checkout
                    
                    let footerView = tableProvider.tableView(tableView, viewForFooterInSection: CheckoutSection.shippingOptions.rawValue)
                    expect(footerView).to(beAnInstanceOf(PaymentDetailsFooterView.self))
                }
            }
            
            context("if checkout doesn't exist") {
                it("should return nil") {
                    let footerView = tableProvider.tableView(tableView, viewForFooterInSection: 0)
                    expect(footerView).to(beNil())
                }
            }
        }
    }
}
