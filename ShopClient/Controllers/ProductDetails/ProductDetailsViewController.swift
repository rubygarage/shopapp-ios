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
    var selectedVariant: ProductVariant?

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupViews()
        loadRemoteData()
    }
    
    // MARK: - setup
    func setupData() {
        selectedVariant = product?.variants?.first
        if selectedOptions.count == 0 {
            setupSelectedOptions()
        }
    }
    
    private func setupSelectedOptions() {
        if let options = product?.options {
            for option in options {
                selectedOptions.append((name: option.name ?? String(), value: option.values?.first ?? String()))
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
    
    private func updateOptionsViews() {
        populatePrice()
        populateAddToCartButton()
        populateOptionsView()
    }
    
    private func populatePrice() {
        priceLabel.text = "\(selectedVariant?.price ?? String()) \(product?.currency ?? String())"
        priceLabel.isHidden = selectedVariant?.available == nil
    }
    
    private func populateAddToCartButton() {
        let enabled = selectedVariant != nil
        addToCartButton.backgroundColor = enabled ? UIColor.blue : UIColor.lightGray
        addToCartButton.isEnabled = enabled
    }
    
    private func populateOptionsView() {
        if let options = product?.options {
            openProductOptionsController(with: options, selectedOptions: selectedOptions, delegate: self, onView: optionsContainerView)
        }
    }
    
    // MARK: - remote
    private func loadRemoteData() {
        Repository.shared.getProduct(id: productId) { [weak self] (product, error) in
            if let productObject = product {
                self?.product = productObject
                self?.setupData()
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
        if let variants = product?.variants {
            findVariant(variants: variants)
        }
    }
    
    private func findVariant(variants: [ProductVariant]) {
        let selectedOptionsNames = selectedOptions.map({ $0.name })
        let selectedOptionsNValues = selectedOptions.map({ $0.value })
        
        for variant in variants {
            let variantNames = variant.selectedOptions?.map({ $0.name }) ?? [String()]
            let variantValues = variant.selectedOptions?.map({ $0.value }) ?? [String()]
            
            if selectedOptionsNames == variantNames && selectedOptionsNValues == variantValues {
                selectedVariant = variant
                updateOptionsViews()
                break
            }
        }
    }
}
