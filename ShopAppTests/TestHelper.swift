//
//  TestHelper.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 6/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation
import ShopApp_Gateway

@testable import ShopApp

struct TestHelper {
    static var fullAddress: Address {
        return Address(id: "id", firstName: "first", lastName: "last", street: "address", secondStreet: "second", city: "city", country: "country", state: "state", zip: "zip", phone: "phone")
    }
    
    static var partialAddress: Address {
        return Address(id: "id", firstName: "first", lastName: "last", street: "address", city: "city", country: "country", zip: "zip")
    }
    
    static var fullArticle: Article {
        return Article(id: "id", title: "title", content: "content", contentHtml: "html", image: image, author: author, paginationValue: "pagination")
    }
    
    static var partialArticle: Article {
        return Article(id: "id", title: "title", content: "content", contentHtml: "html", author: author)
    }
    
    static var author: Author {
        return Author(firstName: "first", lastName: "last")
    }
    
    static var card: Card {
        return Card(firstName: "first", lastName: "last", cardNumber: "4242424242424242", expireMonth: "month", expireYear: "year", verificationCode: "code")
    }
    
    static var cartProductWithQuantityZero: CartProduct {
        return CartProduct(id: "id", productVariant: productVariantWithoutSelectedOptions, title: "title", currency: "UAH", quantity: 0)
    }
    
    static var cartProductWithQuantityOne: CartProduct {
        return CartProduct(id: "id", productVariant: productVariantWithoutSelectedOptions, title: "title", currency: "UAH", quantity: 1)
    }
    
    static var cartProductWithQuantityTwo: CartProduct {
        return CartProduct(id: "id", productVariant: productVariantWithoutSelectedOptions, title: "title", currency: "UAH", quantity: 2)
    }
    
    static var cartProductWithoutProductVariant: CartProduct {
        return CartProduct(id: "id", title: "title", currency: "UAH", quantity: 2)
    }
    
    static var categoryWithFiveProducts: ShopApp_Gateway.Category {
        let products = (1...5).map { _ in
            return productWithoutAlternativePrice
        }
        
        return categoryWithProducts(products)
    }
    
    static var categoryWithTenProducts: ShopApp_Gateway.Category {
        let products = (1...10).map { _ in
            return productWithoutAlternativePrice
        }
        
        return categoryWithProducts(products)
    }
    
    static var checkoutWithShippingAddress: Checkout {
        return Checkout(id: "id", subtotalPrice: Decimal(10), totalPrice: Decimal(15), currency: "UAH", shippingAddress: fullAddress, shippingRate: shippingRate, availableShippingRates: [shippingRate], lineItems: [LineItem()])
    }
    
    static var checkoutWithoutShippingAddress: Checkout {
        return Checkout(id: "id", subtotalPrice: Decimal(10), totalPrice: Decimal(15), currency: "UAH", shippingRate: shippingRate, availableShippingRates: [shippingRate], lineItems: [LineItem()])
    }
    
    static var customerWithoutAcceptsMarketing: Customer {
        return Customer(id: "id", email: "email", firstName: "first", lastName: "last", phone: "phone", isAcceptsMarketing: false, defaultAddress: fullAddress, addresses: [fullAddress])
    }
    
    static var customerWithAcceptsMarketing: Customer {
        return Customer(id: "id", email: "email", firstName: "first", lastName: "last", phone: "phone", isAcceptsMarketing: true, defaultAddress: fullAddress, addresses: [fullAddress])
    }
    
    static var image: Image {
        return Image(id: "", src: "")
    }
    
    static var orderWithProducts: Order {
        return Order(id: "id", currencyCode: "UAH", orderNumber: 1, subtotalPrice: Decimal(10), totalShippingPrice: Decimal(5), totalPrice: Decimal(15), createdAt: Date(), orderProducts: [orderProductWithoutSelectedOptions], shippingAddress: partialAddress, paginationValue: "pagination")
    }
    
    static var orderWithoutProducts: Order {
        return Order(id: "id", currencyCode: "UAH", orderNumber: 1, subtotalPrice: Decimal(10), totalShippingPrice: Decimal(5), totalPrice: Decimal(15), createdAt: Date(), orderProducts: [], shippingAddress: partialAddress, paginationValue: "pagination")
    }
    
    static var orderProductWithoutProductVariant: OrderProduct {
        return OrderProduct(title: "title", quantity: 2)
    }
    
    static var orderProductWithoutSelectedOptions: OrderProduct {
        return OrderProduct(title: "title", quantity: 2, productVariant: productVariantWithoutSelectedOptions)
    }
    
    static var orderProductWithSelectedOptions: OrderProduct {
        return OrderProduct(title: "title", quantity: 2, productVariant: productVariantWithSelectedOptions)
    }
    
    static var policy: Policy {
        return Policy(title: "title", body: "body", url: "url")
    }
    
    static var productWithoutAlternativePrice: Product {
        return Product(id: "id", title: "title", productDescription: "description", price: Decimal(10), hasAlternativePrice: false, currency: "UAH", discount: "discount", images: [image], type: "type", paginationValue: "pagination", variants: [productVariantWithoutSelectedOptions], options: [productOptionWithOneValue])
    }
    
    static var productWithAlternativePrice: Product {
        return Product(id: "id", title: "title", productDescription: "description", price: Decimal(10), hasAlternativePrice: true, currency: "UAH", discount: "discount", images: [image], type: "type", paginationValue: "pagination", variants: [productVariantWithoutSelectedOptions], options: [productOptionWithOneValue])
    }
    
    static var productWithoutImages: Product {
        return Product(id: "id", title: "title", productDescription: "description", price: Decimal(10), hasAlternativePrice: false, currency: "UAH", discount: "discount", images: [], type: "type", paginationValue: "pagination", variants: [productVariantWithoutSelectedOptions], options: [productOptionWithOneValue])
    }
    
    static var productOptionWithOneValue: ProductOption {
        return ProductOption(id: "id", name: "name", values: ["value"])
    }
    
    static var productOptionWithFewValues: ProductOption {
        return ProductOption(id: "id", name: "name", values: ["firstValue", "secondValue"])
    }
    
    static var productVariantWithoutSelectedOptions: ProductVariant {
        return ProductVariant(id: "id", title: "title", price: Decimal(10), isAvailable: true, image: image, selectedOptions: [], productId: "productId")
    }
    
    static var productVariantWithSelectedOptions: ProductVariant {
        return ProductVariant(id: "id", title: "title", price: Decimal(10), isAvailable: true, image: image, selectedOptions: [variantOption, variantOption], productId: "productId")
    }
    
    static var shippingRate: ShippingRate {
        return ShippingRate(title: "title", price: Decimal(10), handle: "handle")
    }
    
    static var shop: Shop {
        return Shop(privacyPolicy: policy, refundPolicy: policy, termsOfService: policy)
    }
    
    static var variantOption: VariantOption {
        return VariantOption(name: "name", value: "value")
    }
    
    private static func categoryWithProducts(_ products: [Product]) -> ShopApp_Gateway.Category {
        return ShopApp_Gateway.Category(id: "id", title: "title", image: image, products: products, paginationValue: "pagination")
    }
}
