//
//  UIViewControllerRoutes.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/5/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import SideMenu

extension UIViewController {
    
    // MARK: - push
    func pushSearchController() {
        pushController(with: UIStoryboard.search(), identifier: ControllerIdentifier.search)
    }
    
    func pushLastArrivalsController() {
        pushController(with: UIStoryboard.lastArrivals(), identifier: ControllerIdentifier.lastArrivals)
    }
    
    func pushArticlesListController() {
        pushController(with: UIStoryboard.articlesList(), identifier: ControllerIdentifier.articlesList)
    }
    
    func pushDetailController(with product: Product) {
        let detaillController = UIStoryboard.productDetails().instantiateViewController(withIdentifier: ControllerIdentifier.detail) as! DetailViewController
        detaillController.productId = product.id
        detaillController.product = product
        
        navigationController?.pushViewController(detaillController, animated: true)
    }
    
    func pushPolicyController(with policy: Policy) {
        let policyController = UIStoryboard.policy().instantiateViewController(withIdentifier: ControllerIdentifier.policy) as! PolicyViewController
        policyController.policy = policy

        navigationController?.pushViewController(policyController, animated: false)
    }
    
    // MARK: - set
    func setCategoryController(with categoryId: String, title: String) {
        let categoryController = UIStoryboard.category().instantiateViewController(withIdentifier: ControllerIdentifier.category) as! CategoryViewController
        categoryController.categoryId = categoryId
        categoryController.categoryTitle = title
        
        setController(with: categoryController)
    }
    
    func setHomeController() {
        let homeController = UIStoryboard.main().instantiateViewController(withIdentifier: ControllerIdentifier.home) as! HomeViewController
        setController(with: homeController)
    }
    
    // MARK: - open as child
    func openImagesCarouselChildController(with images: [Image], delegate: ImagesCarouselViewControllerProtocol?, showingIndex: Int, onView: UIView) {
        let detailImagesController = UIStoryboard.imagesCarousel().instantiateViewController(withIdentifier: ControllerIdentifier.imagesCarousel) as! ImagesCarouselViewController
        detailImagesController.images = images
        detailImagesController.controllerDelegate = delegate
        detailImagesController.showingIndex = showingIndex
        
        configureChildViewController(childController: detailImagesController, onView: onView)
    }
    
    // MARK: - private
    private func pushController(with storyBoard: UIStoryboard, identifier: String, animated: Bool = true) {
        let controller = storyBoard.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func setController(with controller: UIViewController) {
        controller.addMenuBarButton()
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let navigationController = appDelegate.window!.rootViewController as! UINavigationController
        navigationController.setViewControllers([controller], animated: false)
        
        SideMenuManager.menuLeftNavigationController?.dismiss(animated: true)
    }
}
