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
        if let options = product?.optionsArray {
            for option in options {
                selectedOptions.append((name: option.name ?? String(), value: option.valuesArray.first ?? String()))
            }
        }
    }
    
    private func setupViews() {
        addToCartButton.setTitle(NSLocalizedString("Button.AddToCart", comment: String()), for: .normal)
        addToCartButton.layer.cornerRadius = CornerRadius.defaultValue
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
        if let images = product.imagesArray {
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
        priceLabel.text = "\(product?.variantBySelectedOptions?.price ?? String()) \(product?.currency ?? String())"
        priceLabel.isHidden = product?.variantBySelectedOptions == nil
    }
    
    private func populateAddToCartButton() {
        let enabled = product?.variantBySelectedOptions != nil
        addToCartButton.backgroundColor = enabled ? UIColor.blue : UIColor.lightGray
        addToCartButton.isEnabled = enabled
    }
    
    private func populateOptionsView() {
        if let options = product?.optionsArray {
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
