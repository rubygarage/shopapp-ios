//
//  ProductDetailsViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/15/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway
import Toaster
import TPKeyboardAvoiding

@testable import ShopApp

class ProductDetailsViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: ProductDetailsViewController!
        var viewModelMock: ProductDetailsViewModelMock!
        
        var contentView: TPKeyboardAvoidingScrollView!
        var detailImagesContainer: UIView!
        var titleLabel: UILabel!
        var descriptionStateImageView: UIImageView!
        var descriptionLabel: UILabel!
        var priceLabel: UILabel!
        var quantityTitleLabel: UILabel!
        var quantityTextFieldView: QuantityTextFieldView!
        var addToCartButton: UIButton!
        var bottomView: UIView!
        var relatedItemsHeaderView: SeeAllTableHeaderView!
        var relatedItemsView: LastArrivalsTableViewCell!
        var collectionView: UICollectionView!
        var descriptionView: UIView!
        var descriptionContainerViewHeightConstraint: NSLayoutConstraint!
        var optionsContainerViewHeightConstraint: NSLayoutConstraint!
        var descriptionContainerDidTapRecognizer: UITapGestureRecognizer!
        
        func setupViews() {
            contentView = self.findView(withAccessibilityLabel: "contentView", in: viewController.view) as! TPKeyboardAvoidingScrollView
            detailImagesContainer = self.findView(withAccessibilityLabel: "detailImagesContainer", in: viewController.view)
            titleLabel = self.findView(withAccessibilityLabel: "titleLabel", in: viewController.view) as! UILabel
            descriptionStateImageView = self.findView(withAccessibilityLabel: "descriptionStateImageView", in: viewController.view) as! UIImageView
            descriptionLabel = self.findView(withAccessibilityLabel: "descriptionLabel", in: viewController.view) as! UILabel
            priceLabel = self.findView(withAccessibilityLabel: "priceLabel", in: viewController.view) as! UILabel
            quantityTitleLabel = self.findView(withAccessibilityLabel: "quantityTitleLabel", in: viewController.view) as! UILabel
            quantityTextFieldView = self.findView(withAccessibilityLabel: "quantityTextFieldView", in: viewController.view) as! QuantityTextFieldView
            addToCartButton = self.findView(withAccessibilityLabel: "addToCartButton", in: viewController.view) as! UIButton
            bottomView = self.findView(withAccessibilityLabel: "bottomView", in: viewController.view)
            relatedItemsHeaderView = self.findView(withAccessibilityLabel: "relatedItemsHeaderView", in: viewController.view) as! SeeAllTableHeaderView
            relatedItemsView = self.findView(withAccessibilityLabel: "relatedItemsView", in: viewController.view) as! LastArrivalsTableViewCell
            collectionView = self.findView(withAccessibilityLabel: "collectionView", in: viewController.view) as! UICollectionView
            descriptionView = self.findView(withAccessibilityLabel: "descriptionView", in: viewController.view)
            descriptionContainerViewHeightConstraint = descriptionLabel.superview?.constraints.filter({ $0.accessibilityLabel == "descriptionContainerViewHeightConstraint" }).first
            let containerView = self.findView(withAccessibilityLabel: "containerView", in: viewController.view)
            optionsContainerViewHeightConstraint = containerView?.constraints.filter({ $0.accessibilityLabel == "optionsContainerViewHeightConstraint" }).first
            descriptionContainerDidTapRecognizer = descriptionView?.gestureRecognizers?.filter({ $0.accessibilityLabel == "descriptionContainerDidTap" }).first as! UITapGestureRecognizer
        }
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.main, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.productDetails) as! ProductDetailsViewController
            
            let navigationController = NavigationController(rootViewController: UIViewController())
            navigationController.pushViewController(viewController, animated: false)
            
            let cartRepositoryMock = CartRepositoryMock()
            let addCartProductUseCaseMock = AddCartProductUseCaseMock(repository: cartRepositoryMock)
            
            let productRepositoryMock = ProductRepositoryMock()
            let productUseCaseMock = ProductUseCaseMock(repository: productRepositoryMock)
            let productListUseCaseMock = ProductListUseCaseMock(repository: productRepositoryMock)
            
            viewModelMock = ProductDetailsViewModelMock(addCartProductUseCase: addCartProductUseCaseMock, productUseCase: productUseCaseMock, productListUseCase: productListUseCaseMock)
            viewController.viewModel = viewModelMock
        }
        
        describe("when view loaded") {
            beforeEach {
                setupViews()
                viewController.viewWillAppear(false)
            }
            
            it("should have a correct superclass") {
                expect(viewController).to(beAKindOf(BaseViewController<ProductDetailsViewModel>.self))
            }
            
            it("should have correct content view class") {
                expect(contentView).to(beAnInstanceOf(TPKeyboardAvoidingScrollView.self))
            }
            
            it("should have cart button") {
                expect(viewController.navigationItem.rightBarButtonItem?.customView?.subviews.first).to(beAKindOf(CartButtonView.self))
            }
            
            it("should have correct quantity title label text") {
                expect(quantityTitleLabel.text) == "Label.Quantity".localizable
            }
            
            it("should have correct add to cart button states") {
                expect(addToCartButton.title(for: .normal)) == "Button.AddToCart".localizable.uppercased()
                expect(addToCartButton.title(for: .disabled)) == "Button.ProductTemporaryUnavailable".localizable.uppercased()
            }
            
            it("should have correct view model class") {
                expect(viewController.viewModel).to(beAKindOf(BaseViewModel.self))
            }
            
            it("should have correct related items view delegate") {
                expect(relatedItemsView.delegate) === viewController
            }
            
            it("should have correct related items header view delegate") {
                expect(relatedItemsHeaderView.delegate) === viewController
            }
            
            it("should have gesture recognizers", closure: {
                expect(descriptionView.gestureRecognizers?.isEmpty) == false
            })
            
            it("should start data loading") {
                expect(viewModelMock.isLoadDataStarted) == true
            }
        }
        
        describe("when data did pass to view model") {
            context("if view controller opened from product details screen") {
                beforeEach {
                    viewController.productId = "Product id"
                }
                
                it("should correct pass product id to view model") {
                    setupViews()
                    
                    expect(viewController.viewModel.productId) == viewController.productId
                }
            }
            
            context("if view controller opened from order screen") {
                var productVariant: ProductVariant!
                
                beforeEach {
                    productVariant = ProductVariant()
                    productVariant.productId = "Product id"
                    viewController.productVariant = productVariant
                }
                
                it("should correct pass product id to view model") {
                    setupViews()
                    
                    expect(viewController.viewModel.productId) == productVariant.productId
                    expect(viewController.viewModel.productVariant) === viewController.productVariant
                }
            }
        }
        
        describe("when quantity changed") {
            beforeEach {
                setupViews()
            }
            
            it("should update quantity in view model") {
                quantityTextFieldView.text = "5"
                quantityTextFieldView.textField.sendActions(for: .editingDidEnd)
                
                expect(viewController.viewModel.quantity.value) == 5
            }
            
            it("should set default value to view model") {
                quantityTextFieldView.text = nil
                quantityTextFieldView.textField.sendActions(for: .editingDidEnd)
                
                expect(viewController.viewModel.quantity.value) == 1
            }
            
            it("should set default value to view model") {
                quantityTextFieldView.text = ""
                quantityTextFieldView.textField.sendActions(for: .editingDidEnd)
                
                expect(viewController.viewModel.quantity.value) == 1
            }
        }
        
        describe("when product loaded") {
            beforeEach {
                setupViews()
            }
            
            context("if product not filled") {
                beforeEach {
                    viewModelMock.isNeedToFillProduct = false
                }
                
                it("should load product") {
                    viewController.viewModel.loadData()
                    
                    expect(detailImagesContainer.isHidden) == true
                    expect(titleLabel.text).to(beNil())
                    expect(descriptionLabel.text).to(beNil())
                }
            }
            
            context("if product filled") {
                beforeEach {
                    viewModelMock.isNeedToFillProduct = true
                }
                
                it("should load product") {
                    viewController.viewModel.loadData()
                    
                    expect(detailImagesContainer.isHidden) == false
                    expect(titleLabel.text) == "Product title"
                    expect(descriptionLabel.text) == "Product description"
                }
            }
        }
        
        describe("when related items loaded") {
            beforeEach {
                setupViews()
            }
            
            context("if items count less than 10") {
                beforeEach {
                    viewModelMock.isRelatedItemsCountMoreThenConstant = false
                }

                it("should load 5 related items") {
                    viewController.viewModel.loadData()

                    expect(collectionView.numberOfItems(inSection: 0)) == 5
                }
            }
            
            context("if items count greater than or equal 10") {
                beforeEach {
                    viewModelMock.isRelatedItemsCountMoreThenConstant = true
                }
                
                it("should load 15 related items") {
                    viewController.viewModel.loadData()
                    
                    expect(collectionView.numberOfItems(inSection: 0)) == 15
                }
            }
        }
        
        describe("when option selected") {
            beforeEach {
                setupViews()
                viewModelMock.isNeedToFillProduct = true
                viewModelMock.loadData()
            }
            
            context("if selected variant not filled") {
                beforeEach {
                    viewModelMock.makeSelectedVariant(filled: false)
                }
                
                it("should hide price label") {
                    expect(priceLabel.isHidden) == true
                }
                
                it("should disable add to cart button") {
                    expect(addToCartButton.isEnabled) == false
                }
                
                it("should have correct bottom view background color") {
                    expect(bottomView.backgroundColor) == UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
                }
            }
            
            context("if selected variant filled") {
                beforeEach {
                    viewModelMock.makeSelectedVariant(filled: true)
                }
                
                it("should show correct price label") {
                    let formatter = NumberFormatter.formatter(with: "USD")
                    let price = NSDecimalNumber(decimal: Decimal(floatLiteral: 10))
                    let expectedText = formatter.string(from: price)
                    
                    expect(priceLabel.isHidden) == false
                    expect(priceLabel.text) == expectedText
                }
                
                it("should disable add to cart button") {
                    expect(addToCartButton.isEnabled) == true
                }
                
                it("should have correct bottom view background color") {
                    expect(bottomView.backgroundColor) == UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
                }
            }
        }
        
        describe("when add product to cart did press") {
            beforeEach {
                setupViews()
            }
            
            context("if product added sucessfully") {
                beforeEach {
                    viewModelMock.isNeedToAddProductToCart = true
                }
                
                it("should show toast") {
                    addToCartButton.sendActions(for: .touchUpInside)
                    
                    expect(ToastCenter.default.currentToast?.text) == "Alert.ProductAdded".localizable
                }
            }
            
            context("and if failed") {
                beforeEach {
                    viewModelMock.isNeedToAddProductToCart = false
                }
                
                it("shouldn't show toast") {
                    addToCartButton.sendActions(for: .touchUpInside)
                    
                    expect(ToastCenter.default.currentToast).to(beNil())
                }
            }
            
            afterEach {
                ToastCenter.default.cancelAll()
            }
        }
        
        describe("when description did press") {
            beforeEach {
                viewModelMock.isNeedToFillProduct = true
            }
            
            it("should open and close description") {
                setupViews()
                
                viewController.descriptionContainerDidTap(descriptionContainerDidTapRecognizer)
                
                expect(descriptionStateImageView.image) == #imageLiteral(resourceName: "minus")
                expect(descriptionContainerViewHeightConstraint.constant) == descriptionLabel.frame.size.height + 40 // 40 is a productDescriptionAdditionalHeight constant
                
                viewController.descriptionContainerDidTap(descriptionContainerDidTapRecognizer)
                
                expect(descriptionStateImageView.image) == #imageLiteral(resourceName: "plus")
                expect(descriptionContainerViewHeightConstraint.constant) == 0
            }
        }
        
        describe("when options height constraint did change") {
            beforeEach {
                setupViews()
            }
            
            it("should set options height constraint") {
                let controller = ProductOptionsViewController()
                viewController.viewController(controller, didCalculate: 100)
                
                expect(optionsContainerViewHeightConstraint.constant) == 100
            }
        }
        
        describe("when option did select") {
            beforeEach {
                setupViews()
            }
            
            it("should start option selection") {
                let controller = ProductOptionsViewController()
                let  option = (name: "Option name", value: "Option value")
                viewController.viewController(controller, didSelect: option)
                
                expect(viewModelMock.selectedOptionName) == option.name
                expect(viewModelMock.selectedOptionValue) == option.value
            }
        }
    }
}
