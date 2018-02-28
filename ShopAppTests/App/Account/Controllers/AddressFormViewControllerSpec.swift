//
//  AddressFormViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class AddressFormViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: AddressFormViewController!
        var viewModelMock: AddressFormViewModelMock!
        var delegateMock: AddressFormControllerlDelegateMock!
        var countryPicker: BasePicker!
        var nameTextFieldView: InputTextFieldView!
        var lastNameTextFieldView: InputTextFieldView!
        var addressTextFieldView: InputTextFieldView!
        var addressOptionalTextFieldView: InputTextFieldView!
        var cityTextFieldView: InputTextFieldView!
        var statePicker: BasePicker!
        var zipCodeTextFieldView: InputTextFieldView!
        var phoneTextFieldView: InputTextFieldView!
        var submitButton: BlackButton!
        var address: Address!
        
        describe("when view loaded") {
            beforeEach {
                initData(addressNeeded: false)
            }
            
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(AddressFormViewModel.self))
            }
            
            it("should have pickers with correct placeholders") {
                expect(countryPicker.placeholder) == "Placeholder.Country".localizable.required.uppercased()
                expect(statePicker.placeholder) == "Placeholder.State".localizable.uppercased()
            }
            
            it("should have text field views with correct placeholders") {
                expect(nameTextFieldView.placeholder) == "Placeholder.Name".localizable.required.uppercased()
                expect(lastNameTextFieldView.placeholder) == "Placeholder.LastName".localizable.required.uppercased()
                expect(addressTextFieldView.placeholder) == "Placeholder.Address".localizable.required.uppercased()
                expect(addressOptionalTextFieldView.placeholder) == "Placeholder.AddressOptional".localizable.uppercased()
                expect(cityTextFieldView.placeholder) == "Placeholder.City".localizable.required.uppercased()
                expect(zipCodeTextFieldView.placeholder) == "Placeholder.ZipCode".localizable.required.uppercased()
                expect(phoneTextFieldView.placeholder) == "Placeholder.PhoneNumber".localizable.required.uppercased()
            }
            
            it("should have button with correct title") {
                expect(submitButton.title(for: .normal)) == "Button.Submit".localizable.uppercased()
            }
        }
        
        describe("when address did set") {
            context("if data is empty") {
                beforeEach {
                    initData(addressNeeded: false)
                }
                
                it("should have empty pickers") {
                    expect(countryPicker.text) == ""
                    expect(statePicker.text) == ""
                }
                
                it("should have empty text fields") {
                    expect(nameTextFieldView.text) == ""
                    expect(lastNameTextFieldView.text) == ""
                    expect(addressTextFieldView.text) == ""
                    expect(addressOptionalTextFieldView.text) == ""
                    expect(cityTextFieldView.text) == ""
                    expect(zipCodeTextFieldView.text) == ""
                    expect(phoneTextFieldView.text) == ""
                }
                
                it("should have empty view model properties") {
                    expect(viewController.viewModel.countryText.value) == ""
                    expect(viewController.viewModel.firstNameText.value) == ""
                    expect(viewController.viewModel.lastNameText.value) == ""
                    expect(viewController.viewModel.addressText.value) == ""
                    expect(viewController.viewModel.addressOptionalText.value) == ""
                    expect(viewController.viewModel.cityText.value) == ""
                    expect(viewController.viewModel.stateText.value) == ""
                    expect(viewController.viewModel.zipText.value) == ""
                    expect(viewController.viewModel.phoneText.value) == ""
                }
                
                it("should have correct view model initial properties") {
                    expect(viewController.viewModel.address).to(beNil())
                }
            }
            
            context("if data isn't empty") {
                beforeEach {
                    initData(addressNeeded: true)
                }
                
                it("should have not empty pickers") {
                    expect(countryPicker.text) == "country"
                    expect(statePicker.text) == "state"
                }
                
                it("should have not empty text fields") {
                    expect(nameTextFieldView.text) == "first name"
                    expect(lastNameTextFieldView.text) == "last name"
                    expect(addressTextFieldView.text) == "address"
                    expect(addressOptionalTextFieldView.text) == "second address"
                    expect(cityTextFieldView.text) == "city"
                    expect(zipCodeTextFieldView.text) == "zip"
                    expect(phoneTextFieldView.text) == "phone"
                }
                
                it("should have correct view model properties") {
                    expect(viewController.viewModel.countryText.value) == "country"
                    expect(viewController.viewModel.firstNameText.value) == "first name"
                    expect(viewController.viewModel.lastNameText.value) == "last name"
                    expect(viewController.viewModel.addressText.value) == "address"
                    expect(viewController.viewModel.addressOptionalText.value) == "second address"
                    expect(viewController.viewModel.cityText.value) == "city"
                    expect(viewController.viewModel.stateText.value) == "state"
                    expect(viewController.viewModel.zipText.value) == "zip"
                    expect(viewController.viewModel.phoneText.value) == "phone"
                }
                
                it("should have correct view model initial properties") {
                    expect(viewController.viewModel.address).toNot(beNil())
                }
            }
        }
         
        describe("when text field views text changed") {
            beforeEach {
                initData(addressNeeded: false)
            }
            
            it("should have correct view model countryText binding") {
                countryPicker.text = "Country"
                countryPicker.textField.sendActions(for: .editingChanged)
                expect(viewModelMock.countryText.value) == "Country"
            }
            
            it("should have correct view model firstNameText binding") {
                nameTextFieldView.text = "First name"
                nameTextFieldView.textField.sendActions(for: .editingChanged)
                expect(viewModelMock.firstNameText.value) == "First name"
            }
            
            it("should have correct view model lastNameText binding") {
                lastNameTextFieldView.text = "Last name"
                lastNameTextFieldView.textField.sendActions(for: .editingChanged)
                expect(viewModelMock.lastNameText.value) == "Last name"
            }
            
            it("should have correct view model addressText binding") {
                addressTextFieldView.text = "Address"
                addressTextFieldView.textField.sendActions(for: .editingChanged)
                expect(viewModelMock.addressText.value) == "Address"
            }
            
            it("should have correct view model addressOptionalText binding") {
                addressOptionalTextFieldView.text = "Address"
                addressOptionalTextFieldView.textField.sendActions(for: .editingChanged)
                expect(viewModelMock.addressOptionalText.value) == "Address"
            }
            
            it("should have correct view model cityText binding") {
                cityTextFieldView.text = "City"
                cityTextFieldView.textField.sendActions(for: .editingChanged)
                expect(viewModelMock.cityText.value) == "City"
            }
            
            it("should have correct view model stateText binding") {
                statePicker.text = "State"
                statePicker.textField.sendActions(for: .editingChanged)
                expect(viewModelMock.stateText.value) == "State"
            }
            
            it("should have correct view model zipText binding") {
                zipCodeTextFieldView.text = "Zip"
                zipCodeTextFieldView.textField.sendActions(for: .editingChanged)
                expect(viewModelMock.zipText.value) == "Zip"
            }
            
            it("should have correct view model phoneText binding") {
                phoneTextFieldView.text = "Phone"
                phoneTextFieldView.textField.sendActions(for: .editingChanged)
                expect(viewModelMock.phoneText.value) == "Phone"
            }
        }
        
        describe("when pickers did changes") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                initData(addressNeeded: false)
                disposeBag = DisposeBag()
            }
            
            it("should have correct view model namesOfCountries binding") {
                viewModelMock.makeNameOfCountries(with: ["Country1"])
                expect(countryPicker.customData) == ["Country1"]
            }
            
            it("should have correct view model namesOfStates binding") {
                viewModelMock.makeNameOfStates(with: ["State1"])
                expect(statePicker.customData) == ["State1"]
            }
            
            it("should select country correctly") {
                viewModelMock.makeNameOfCountries(with: ["Country1"])
                countryPicker.pickerView.selectRow(0, inComponent: 0, animated: false)
                
                let toolbar = countryPicker.textField.inputAccessoryView as? UIToolbar
                let doneButton = toolbar?.items?.filter({ $0.title == "Button.Done".localizable }).first
                UIApplication.shared.sendAction(doneButton!.action!, to: doneButton!.target, from: nil, for: nil)
                
                countryPicker.textField.sendActions(for: .editingChanged)
                expect(viewController.viewModel.countryText.value) == "Country1"
            }
            
            it("should select state correctly") {
                viewModelMock.makeNameOfStates(with: ["State1"])
                statePicker.pickerView.selectRow(0, inComponent: 0, animated: false)
                
                let toolbar = statePicker.textField.inputAccessoryView as? UIToolbar
                let doneButton = toolbar?.items?.filter({ $0.title == "Button.Done".localizable }).first
                UIApplication.shared.sendAction(doneButton!.action!, to: doneButton!.target, from: nil, for: nil)
                
                statePicker.textField.sendActions(for: .editingChanged)
                expect(viewController.viewModel.stateText.value) == "State1"
            }
        }
        
        describe("when submit button tapped") {
            beforeEach {
                initData(addressNeeded: false)
            }
            
            it("should have correct submit button tap binding") {
                submitButton.sendActions(for: .touchUpInside)
                expect(viewModelMock.submitButtonDidPress) == true
            }
        }
        
        describe("when submit button state changed") {
            beforeEach {
                initData(addressNeeded: false)
            }
            
            it("should return addressValid false") {
                viewModelMock.addressValid.value = false
                expect(submitButton.isEnabled) == false
            }
            
            it("should return addressValid true") {
                viewModelMock.addressValid.value = true
                expect(submitButton.isEnabled) == true
            }
        }
        
        describe("when submit tapped") {
            beforeEach {
                initData(addressNeeded: true)
            }
            
            it("should return correct address") {
                viewModelMock.makeSubmitAction()
                expect(delegateMock.filledAddress).toNot(beNil())
            }
        }
        
        func initData(addressNeeded: Bool) {
            viewController = UIStoryboard(name: StoryboardNames.account, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.addressForm) as! AddressFormViewController
            
            let repositoryMock = PaymentsRepositoryMock()
            let countriesUseCaseMock = CountriesUseCaseMock(repository: repositoryMock)
            viewModelMock = AddressFormViewModelMock(countriesUseCase: countriesUseCaseMock)
            viewController.viewModel = viewModelMock
            
            delegateMock = AddressFormControllerlDelegateMock()
            viewController.delegate = delegateMock
            
            if addressNeeded {
                address = Address()
                address.firstName = "first name"
                address.lastName = "last name"
                address.address = "address"
                address.secondAddress = "second address"
                address.city = "city"
                address.country = "country"
                address.state = "state"
                address.zip = "zip"
                address.phone = "phone"
                viewController.address = address
            }
            
            countryPicker = self.findView(withAccessibilityLabel: "addressFormCountryPicker", in: viewController.view) as! BasePicker
            nameTextFieldView = self.findView(withAccessibilityLabel: "addressFormName", in: viewController.view) as! InputTextFieldView
            lastNameTextFieldView = self.findView(withAccessibilityLabel: "addressFormLastName", in: viewController.view) as! InputTextFieldView
            addressTextFieldView = self.findView(withAccessibilityLabel: "addressFormAddress", in: viewController.view) as! InputTextFieldView
            addressOptionalTextFieldView = self.findView(withAccessibilityLabel: "addressFormAddressOptional", in: viewController.view) as! InputTextFieldView
            cityTextFieldView = self.findView(withAccessibilityLabel: "addressFormCity", in: viewController.view) as! InputTextFieldView
            statePicker = self.findView(withAccessibilityLabel: "addressFormState", in: viewController.view) as! BasePicker
            zipCodeTextFieldView = self.findView(withAccessibilityLabel: "addressFormZipCode", in: viewController.view) as! InputTextFieldView
            phoneTextFieldView = self.findView(withAccessibilityLabel: "addressFormPhone", in: viewController.view) as! InputTextFieldView
            submitButton = self.findView(withAccessibilityLabel: "addressFormSubmitButton", in: viewController.view) as! BlackButton
        }
    }
}
