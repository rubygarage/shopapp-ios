//
//  Constants.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/5/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

let kItemsPerPage = 10

struct ControllerIdentifier {
    static let home = "HomeControllerIdentifier"
    static let productDetails = "ProductsDetailControllerIdentifier"
    static let imagesCarousel = "ImagesCarouselControllerIdentifier"
    static let menu = "MenuControllerIdentifier"
    static let search = "SearchControllerIdentifier"
    static let category = "CategoryControllerIdentifier"
    static let policy = "PolicyControllerIdentifier"
    static let productsList = "ProductsListControllerIdentifier"
    static let articlesList = "ArticlesListControllerIdentifier"
    static let articleDetails = "ArticleDetailsControllerIdentifier"
    static let sortModal = "SortModalControllerIdentifier"
    static let productOptions = "ProductOptionsControllerIdentifier"
    static let cart = "CartControllerIdetifier"
    static let account = "AccountControllerIdentifier"
    static let auth = "AuthrntificationControllerIdentifier"
    static let checkout = "CheckoutControllerIdentifier"
    static let addressForm = "AddressFormControllerIdentifier"
    static let addressList = "AddressListControllerIdentifier"
    static let billingAddress = "BillingAddressControllerIdentifier"
    static let signIn = "SignInControllerIdentifier"
    static let signUp = "SignUpControllerIdentifier"
}

struct SegueIdentifiers {
    static let toProductsList = "toProductsList"
    static let toProductDetails = "toProductDetails"
    static let toArticlesList = "toArticlesList"
    static let toArticleDetails = "toArticleDetails"
    static let toPolicy = "toPolicy"
    static let toSignIn = "toSignIn"
    static let toSignUp = "toSignUp"
}

struct CornerRadius {
    static let defaultValue: CGFloat = 5
}

struct Layer {
    static let shadowColor = UIColor.lightGray.cgColor
    static let shadowOpacity: Float = 0.5
    static let shadowOffset = CGSize(width: 0, height: 1)
    static let shadowRadius: CGFloat = 1
}

struct SessionData {
    static let keyPrefix = "SessionDataIdentifier"
    static let accessToken = "AccessToken"
    static let expiryDate = "ExpiryDate"
    static let email = "Email"
}

struct StatusCode {
    static let forbidden = 403
    static let unauthorized = 401
    static let notFound = 404
}

struct TableView {
    static let headerFooterMinHeight: CGFloat = 0.001
    static let headerFooterDefaultHeight: CGFloat = 20
    static let defaultContentInsets = UIEdgeInsetsMake(5, 0, 20, 0)
    static let removeActionBackgroundColor = UIColor.backgroundDefault
    static let removeActionFont = UIFont.systemFont(ofSize: 12)
}
