//
//  DetailViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/5/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

typealias SelectedOption = (name: String, value: String)

class ProductDetailsViewController: UIViewController, ImagesCarouselViewControllerProtocol, ProductOptionsControllerProtocol {
    @IBOutlet weak var imagesContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var optionsContainerView: UIView!
    @IBOutlet weak var optionsContainerViewHeightConstraint: NSLayoutConstraint!
    
    var productId = String()
    var product: Product?
    var selectedOptions = [SelectedOption]()
    var detailImagesController: ImagesCarouselViewController?
    var showingImageIndex = 0

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupViews()
        populateViews()
        loadRemoteData()
    }
    
    // MARK: - setup
    func setupData() {
        if let options = product?.productDetails?.options {
            for option in options {
                selectedOptions.append((name: option.name, value: option.values.first ?? String()))
            }
        }
    }
    
    private func setupViews() {
        addToCartButton.setTitle(NSLocalizedString("Button.AddToCart", comment: String()), for: .normal)
    }
    
    private func populateViews() {
        if product != nil {
            populateImages(with: product!)
            populateTitle(with: product!)
            populateDescription(with: product!)
            populatePrice()
            populateAddToCartButton()
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
        priceLabel.text = "\(product?.productDetails?.variantBySelectedOptions?.price ?? String()) \(product?.currency ?? String())"
        priceLabel.isHidden = product?.productDetails?.variantBySelectedOptions == nil
    }
    
    private func populateAddToCartButton() {
        // TODO:
    }
    
    private func populateOptionsView() {
        if let options = product?.productDetails?.options {
            openProductOptionsController(with: options, selectedOptions: selectedOptions, delegate: self, onView: optionsContainerView)
        }
    }
    
    // MARK: - remote
    private func loadRemoteData() {
        ShopCoreAPI.shared.getProduct(id: productId, options: selectedOptions) { [weak self] (product, error) in
            if let productObject = product {
                self?.product = productObject
                self?.populateViews()
            }
        }
    }
    
    // MARK: - actions
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
    
    // MARK: - DetailImagesViewControllerProtocol
    func didShowImage(at index: Int) {
        showingImageIndex = index
    }
    
    // MARK: - ProductOptionsControllerProtocol
    func didCalculate(collectionViewHeight: CGFloat) {
        optionsContainerViewHeightConstraint.constant = collectionViewHeight
    }
    
    func didSelectOption(with name: String, value: String) {
        let selectedOptionsNames = selectedOptions.map({ $0.name })
        if let index = selectedOptionsNames.index(of: name) {
            selectedOptions[index].value = value
        }
        loadRemoteData()
    }
}
