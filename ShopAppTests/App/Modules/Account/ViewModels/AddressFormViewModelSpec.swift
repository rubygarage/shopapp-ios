//
//  AddressFormViewModelSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/26/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class AddressFormViewModelSpec: QuickSpec {
    override func spec() {
        let repositoryMock = PaymentsRepositoryMock()
        let countriesUseCaseMock = CountriesUseCaseMock(repository: repositoryMock)
        let viewModel = AddressFormViewModel(countriesUseCase: countriesUseCaseMock)
        
        describe("when view model initialized") {
            it("should have a correct superclass") {
                expect(viewModel).to(beAKindOf(BaseViewModel.self))
            }
            
            it("should have variables with correct initial values") {
                expect(viewModel.address).to(beNil())
                expect(viewModel.countryText.value) == ""
                expect(viewModel.firstNameText.value) == ""
                expect(viewModel.lastNameText.value) == ""
                expect(viewModel.addressText.value) == ""
                expect(viewModel.addressOptionalText.value) == ""
                expect(viewModel.cityText.value) == ""
                expect(viewModel.stateText.value) == ""
                expect(viewModel.zipText.value) == ""
                expect(viewModel.phoneText.value) == ""
            }
        }
        
        describe("when countries loaded") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            it("should return correct contry names") {
                viewModel.namesOfCountries
                    .subscribe(onNext: { names in
                        expect(names).toEventually(equal(["Country1", "Country2"]))
                    })
                    .disposed(by: disposeBag)
                
                viewModel.getCountries()
            }
        }
        
        describe("when country updated") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if states not found") {
                it("should return empty array") {
                    countriesUseCaseMock.returnStates = false
                    viewModel.getCountries()
                    
                    viewModel.namesOfStates
                        .subscribe(onNext: { names in
                            expect(names.isEmpty) == true
                            expect(viewModel.stateText.value) == ""
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.updateStates(with: "Country1")
                }
            }
            
            context("if states found") {
                it("should return array of states") {
                    countriesUseCaseMock.returnStates = true
                    viewModel.getCountries()
                    
                    viewModel.namesOfStates
                        .subscribe(onNext: { names in
                            expect(names).toEventually(equal(["State1"]))
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.updateStates(with: "Country1")
                }
            }
        }
        
        describe("when submit button did press") {
            var disposeBag: DisposeBag!
            var address: Address!
            
            beforeEach {
                disposeBag = DisposeBag()
                
                address = Address()
                address.id = "Address ID"
                address.firstName = "First name"
                address.lastName = "Last name"
                address.address = "Address"
                address.secondAddress = "Second address"
                address.city = "City"
                address.country = "Country"
                address.state = "State"
                address.zip = "Zip"
                address.phone = "Phone"
            }
            
            it("should return address with correct fields") {
                viewModel.address = address
                viewModel.updateFields()
                
                viewModel.filledAddress
                    .subscribe(onNext: { filledAddress in
                        expect(filledAddress.id) == address.id
                        expect(filledAddress.firstName) == address.firstName
                        expect(filledAddress.lastName) == address.lastName
                        expect(filledAddress.address) == address.address
                        expect(filledAddress.secondAddress) == address.secondAddress
                        expect(filledAddress.city) == address.city
                        expect(filledAddress.country) == address.country
                        expect(filledAddress.state) == address.state
                        expect(filledAddress.zip) == address.zip
                        expect(filledAddress.phone) == address.phone
                    })
                    .disposed(by: disposeBag)
                
                viewModel.submitTapped.onNext()
            }
        }
        
        describe("when address valid state changed") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if address not filled") {
                var invalidAddress: Address!
                
                beforeEach {
                    invalidAddress = Address()
                }
                
                it("should change address valid state to false") {
                    viewModel.address = invalidAddress
                    viewModel.updateFields()
                    
                    viewModel.isAddressValid
                        .subscribe(onNext: { valid in
                            expect(valid) == false
                        })
                        .disposed(by: disposeBag)
                }
            }
            
            context("if address filled") {
                var validAddress: Address!
                
                beforeEach {
                    validAddress = Address()
                    validAddress.firstName = "First name"
                    validAddress.lastName = "Last name"
                    validAddress.address = "Address"
                    validAddress.city = "City"
                    validAddress.country = "Country"
                    validAddress.zip = "Zip"
                    validAddress.phone = "Phone"
                }
                
                it("should change address valid state to false") {
                    viewModel.address = validAddress
                    viewModel.updateFields()
                    
                    viewModel.isAddressValid
                        .subscribe(onNext: { valid in
                            expect(valid) == true
                        })
                        .disposed(by: disposeBag)
                }
            }
        }
    }
}
