//
//  UIViewControllerRoutes.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/5/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - push
    func pushSearchController() {
        pushController(with: UIStoryboard.search(), identifier: ControllerIdentifier.search)
    }
    
    func pushArticlesListController() {
        pushController(with: UIStoryboard.articlesList(), identifier: ControllerIdentifier.articlesList)
    }
    
    func pushDetailController(with product: Product) {
        let productDetaillsController = UIStoryboard.productDetails().instantiateViewController(withIdentifier: ControllerIdentifier.productDetails) as! ProductDetailsViewController
        productDetaillsController.productId = product.id 
        
        navigationController?.pushViewController(productDetaillsController, animated: true)
    }
    
    func pushPolicyController(with policy: Policy) {
        let policyController = UIStoryboard.policy().instantiateViewController(withIdentifier: ControllerIdentifier.policy) as! PolicyViewController
        policyController.policy = policy

        navigationController?.pushViewController(policyController, animated: true)
    }
    
    func pushArticleDetailsController(with articleId: String) {
        let articleDetailsController = UIStoryboard.articleDetails().instantiateViewController(withIdentifier: ControllerIdentifier.articleDetails) as! ArticleDetailsViewController
        articleDetailsController.articleId = articleId
        
        navigationController?.pushViewController(articleDetailsController, animated: true)
    }
    
    func pushProductsListController(with title: String? = nil, sortingValue: SortingValue) {
        let productsListController = UIStoryboard.productsList().instantiateViewController(withIdentifier: ControllerIdentifier.productsList) as! ProductsListViewController
        productsListController.title = title
        productsListController.sortingValue = sortingValue
        
        navigationController?.pushViewController(productsListController, animated: true)
    }
    
    func pushAddressController(with delegate: AddressViewProtocol?) {
        let addressController = UIStoryboard.address().instantiateViewController(withIdentifier: ControllerIdentifier.address) as! AddressViewController
        addressController.delegate = delegate
        
        navigationController?.pushViewController(addressController, animated: true)
    }

    // MARK: - set
    func setHomeController() {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let navigationController = appDelegate.window?.rootViewController as? NavigationController
        let tabbarController = navigationController?.viewControllers.first as? UITabBarController
        tabbarController?.selectedIndex = 0
    }
    
    // MARK: - open as child
    func openImagesCarouselChildController(with images: [Image], delegate: ImagesCarouselViewControllerProtocol?, showingIndex: Int, onView: UIView) {
        let detailImagesController = UIStoryboard.imagesCarousel().instantiateViewController(withIdentifier: ControllerIdentifier.imagesCarousel) as! ImagesCarouselViewController
        detailImagesController.images = images
        detailImagesController.controllerDelegate = delegate
        detailImagesController.showingIndex = showingIndex
        
        configureChildViewController(childController: detailImagesController, onView: onView)
    }
    
    func openProductOptionsController(with options: [ProductOption], selectedOptions: [SelectedOption], delegate: ProductOptionsControllerProtocol?, onView: UIView) {
        let optionsController = UIStoryboard.productOptions().instantiateViewController(withIdentifier: ControllerIdentifier.productOptions) as! ProductOptionsViewController
        optionsController.options = options
        optionsController.selectedOptions = selectedOptions
        optionsController.controllerDelegate = delegate
        
        configureChildViewController(childController: optionsController, onView: onView)
    }
    
    // MARK: - present
    func showCategorySortingController(with items:[String], selectedItem: String, delegate: SortModalControllerProtocol?) {
        let sortController = UIStoryboard.sortModal().instantiateViewController(withIdentifier: ControllerIdentifier.sortModal) as! SortModalViewController
        sortController.sortItems = items
        sortController.selectedSortItem = selectedItem
        sortController.delegate = delegate
        
        sortController.modalPresentationStyle = .overCurrentContext
        sortController.modalTransitionStyle = .crossDissolve
        present(sortController, animated: true)
    }
    
    func showBillingAddressController(with preloadedAddress: Address, delegate: BillingAddressViewProtocol?) {
        let billingAddressController = UIStoryboard.billingAddress().instantiateViewController(withIdentifier: ControllerIdentifier.billingAddress) as! BillingAddressViewController
        billingAddressController.preloadedAddress = preloadedAddress
        billingAddressController.delegate = delegate
        present(billingAddressController, animated: true)
    }
    
    func showSignInController(delegate: AuthenticationProtocol) {
        let signInController = UIStoryboard.auth().instantiateViewController(withIdentifier: ControllerIdentifier.signIn) as! SignInViewController
        signInController.delegate = delegate
        showNavigationController(with: signInController)
    }
    
    func showSignUpController(delegate: AuthenticationProtocol) {
        let signUpController = UIStoryboard.auth().instantiateViewController(withIdentifier: ControllerIdentifier.signUp) as! SignUpViewController
        signUpController.delegate = delegate
        showNavigationController(with: signUpController)
    }
    
    func showCartController() {
        let cartController = UIStoryboard.cart().instantiateViewController(withIdentifier: ControllerIdentifier.cart)
        showNavigationController(with: cartController)
    }
    
    func showCheckoutController() {
        let checkoutController = UIStoryboard.checkout().instantiateViewController(withIdentifier: ControllerIdentifier.checkout)
        showNavigationController(with: checkoutController)
    }
    
    // MARK: - private
    private func pushController(with storyBoard: UIStoryboard, identifier: String, animated: Bool = true) {
        let controller = storyBoard.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showNavigationController(with rootController: UIViewController) {
        let navigationController = NavigationController(rootViewController: rootController)
        present(navigationController, animated: true)
    }
}
