//
//  DetailViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/5/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController, ImagesCarouselViewControllerProtocol {
    @IBOutlet weak var imagesContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var optionsContainerView: UIView!
    
    var productId = String()
    var product: Product?
    var selectedVariant: ProductVariant?
    var detailImagesController: ImagesCarouselViewController?
    var showingImageIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        populateViews()
        loadRemoteData()
    }
    
    func setupData() {
        selectedVariant = product?.productDetails?.variants?.first
    }
    
    private func loadRemoteData() {
        ShopCoreAPI.shared.getProduct(id: productId) { [weak self] (product, error) in
            if let productObject = product {
                self?.product = productObject
                self?.populateViews()
            }
        }
    }
    
    private func populateViews() {
        if product != nil {
            populateImages(with: product!)
            populateTitle(with: product!)
            populateDescription(with: product!)
            updateVariantViews()
            populateOptionsView()
        }
    }
    
    private func populateImages(with product: Product) {
        if let images = product.images {
            openImagesCarouselChildController(with: images, delegate: self, showingIndex: showingImageIndex, onView: imagesContainerView)
        }
    }
    
    private func populateTitle(with product: Product) {
        titleLabel.text = product.title
    }
    
    private func populateDescription(with product: Product) {
        descriptionLabel.text = product.productDescription
    }
    
    private func populatePrice() {
        priceLabel.text = "\(selectedVariant?.price ?? String()) \(product?.currency ?? String())"
    }
    
    private func updateVariantViews() {
        populatePrice()
    }
    
    private func populateOptionsView() {
        openProductOptionsController(onView: optionsContainerView)
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        if let item = product {
            pushImageViewer(with: item, initialIndex: showingImageIndex)
        }
    }
    
    // MARK: - override
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if let item = product {
            populateImages(with: item)
        }
    }
    
    // MARK: - VariantsPickerProtocol
    func didSelect(index: Int) {
        selectedVariant = product?.productDetails?.variants?[index]
        updateVariantViews()
    }
    
    // MARK: - DetailImagesViewControllerProtocol
    func didShowImage(at index: Int) {
        showingImageIndex = index
    }
}
