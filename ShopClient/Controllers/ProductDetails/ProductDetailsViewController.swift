//
//  DetailViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/5/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias SelectedOption = (name: String, value: String)

class ProductDetailsViewController: BaseViewController<ProductDetailsViewModel>, ImagesCarouselViewControllerProtocol, ProductOptionsControllerProtocol {
    @IBOutlet weak var imagesContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var optionsContainerView: UIView!
    @IBOutlet weak var optionsContainerViewHeightConstraint: NSLayoutConstraint!
    
    var productId: String!
    var detailImagesController: ImagesCarouselViewController?
    var showingImageIndex = 0

    // MARK: - life cycle
    override func viewDidLoad() {
        viewModel = ProductDetailsViewModel()
        super.viewDidLoad()

        setupViews()
        setupViewModel()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupBarItemsIfNeeded()
    }
    
    // MARK: - setup
    private func setupViews() {
        addToCartButton.setTitle(NSLocalizedString("Button.AddToCart", comment: String()), for: .normal)
        addToCartButton.layer.cornerRadius = CornerRadius.defaultValue
    }
    
    private func setupViewModel() {
        viewModel.productId = productId
        
        quantityTextField.rx.text.map { Int($0 ?? String()) ?? 1 }
            .bind(to: viewModel.quantity)
            .disposed(by: disposeBag)
        
        viewModel.product.asObservable()
            .subscribe(onNext: { [weak self] product in
                self?.populateViews(product: product)
            })
            .disposed(by: disposeBag)
        
        viewModel.selectedVariant
            .subscribe(onNext: { [weak self] (result) in
                self?.updateOptionsViews(result: result)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.loadData()
    }
    
    private func populateViews(product: Product?) {
        if let product = product {
            populateImages(with: product)
            populateTitle(with: product)
            populateDescription(with: product)
        }
    }
    
    private func updateOptionsViews(result: SelectedVariant) {
        populatePrice(variant: result.variant)
        populateAddToCartButton(variant: result.variant)
        populateOptionsView(allOptions: result.allOptions, selectedOptions: result.selectedOptions)
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
    
    private func populatePrice(variant: ProductVariant?) {
        priceLabel.text = "\(variant?.price ?? String()) \(viewModel.currency ?? String())"
        priceLabel.isHidden = variant == nil
    }
    
    private func populateAddToCartButton(variant: ProductVariant?) {
        let enabled = variant != nil
        addToCartButton.backgroundColor = enabled ? UIColor.blue : UIColor.lightGray
        addToCartButton.isEnabled = enabled
    }
    
    private func populateOptionsView(allOptions: [ProductOption], selectedOptions: [SelectedOption]) {
        openProductOptionsController(with: allOptions, selectedOptions: selectedOptions, delegate: self, onView: optionsContainerView)
    }
    
    private func setupBarItemsIfNeeded() {
        Repository.shared.getCartProductList { [weak self] (cartProducts, _) in
            let cartItemsCount = cartProducts?.count ?? 0
            self?.navigationItem.rightBarButtonItem = cartItemsCount > 0 ? self?.cartBarItem(with: cartItemsCount) : nil
        }
    }
    
    // MARK: - actions
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        if let product = viewModel.product.value {
            pushImageViewer(with: product, initialIndex: showingImageIndex)
        }
    }
    
    @IBAction func addToProductTapped(_ sender: UIButton) {
        viewModel.addToCart
            .subscribe(onNext: { [weak self] success in
                if success {
                    self?.setupBarItemsIfNeeded()
                }
            })
            .disposed(by: disposeBag)
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
        viewModel.selectOption(with: name, value: value)
    }
}
