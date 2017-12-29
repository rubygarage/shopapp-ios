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
    func pushAddressFormController(with address: Address?, completion: AddressFormCompletion?) {
        let addressFormController = UIStoryboard.addressForm().instantiateViewController(withIdentifier: ControllerIdentifier.addressForm) as! AddressFormViewController
        addressFormController.address = address
        addressFormController.completion = completion
        
        navigationController?.pushViewController(addressFormController, animated: true)
    }
    
    func pushAddressListController(with checkoutId: String, selectedAddress: Address, completion: AddressListCompletion?) {
        let addressListController = UIStoryboard.addressList().instantiateViewController(withIdentifier: ControllerIdentifier.addressList) as! AddressListViewController
        addressListController.checkoutId = checkoutId
        addressListController.selectedAddress = selectedAddress
        addressListController.completion = completion
        
        navigationController?.pushViewController(addressListController, animated: true)
    }
    
    func pushPaymentTypeController() {
        let paymentTypeController = UIStoryboard.paymentType().instantiateViewController(withIdentifier: ControllerIdentifier.paymentType) as! PaymentTypeViewController
        
        navigationController?.pushViewController(paymentTypeController, animated: true)
    }

    // MARK: - set
    func setHomeController() {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let navigationController = appDelegate.window?.rootViewController as? NavigationController
        let tabbarController = navigationController?.viewControllers.first as? UITabBarController
        tabbarController?.selectedIndex = 0
    }
    
    // MARK: - open as child    
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
    
    func showCartController() {
        let cartController = UIStoryboard.cart().instantiateViewController(withIdentifier: ControllerIdentifier.cart)
        showNavigationController(with: cartController)
    }
    
    func showCheckoutController() {
        let checkoutController = UIStoryboard.checkout().instantiateViewController(withIdentifier: ControllerIdentifier.checkout)
        showNavigationController(with: checkoutController)
    }
    
    // MARK: - private
    private func showNavigationController(with rootController: UIViewController) {
        let navigationController = NavigationController(rootViewController: rootController)
        present(navigationController, animated: true)
    }
}
