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

private let kQuantityUnderlineColorDefault = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
private let kBottomViewColorEnabled = UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
private let kBottomViewColorDisabled = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
private let kAddToCartChangesAnimationDuration: TimeInterval = 0.33

class ProductDetailsViewController: BaseViewController<ProductDetailsViewModel>, ImagesCarouselViewControllerProtocol, ProductOptionsControllerProtocol {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityTitleLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var quantityUnderlineView: UIView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var optionsContainerView: UIView!
    @IBOutlet weak var optionsContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    
    var productId: String!
    
    private var detailImagesController: ImagesCarouselViewController?
    private var productAddedToCart = false

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
        
        updateNavigationBar()
    }
    
    // MARK: - setup
    private func setupViews() {
        quantityTitleLabel.text = NSLocalizedString("Label.Quantity", comment: String())
        addToCartButton.setTitle(NSLocalizedString("Button.AddToCart", comment: String()).uppercased(), for: .normal)
        addToCartButton.setTitle(NSLocalizedString("Button.ProductTemporaryUnavailable", comment: String()).uppercased(), for: .disabled)
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
            detailImagesController?.images = images
        }
    }
    
    private func populateTitle(with product: Product) {
        titleLabel.text = product.title
    }
    
    private func populateDescription(with product: Product) {
        descriptionLabel.text = product.productDescription
    }
    
    private func populatePrice(variant: ProductVariant?) {
        priceLabel.isHidden = variant == nil
        
        guard let variant = variant else {
            return
        }
        
        let formatter = NumberFormatter.formatter(with: viewModel.currency!)
        let price = NSDecimalNumber(string: variant.price!)
        priceLabel.text = formatter.string(from: price)
    }
    
    private func populateAddToCartButton(variant: ProductVariant?) {
        if !productAddedToCart {
            let variantAvailable = variant != nil
            addToCartButton.isEnabled = variantAvailable
            UIView.animate(withDuration: kAddToCartChangesAnimationDuration, animations: {
                self.bottomView.backgroundColor = variantAvailable ? kBottomViewColorEnabled : kBottomViewColorDisabled
            })
        }
    }
    
    private func populateOptionsView(allOptions: [ProductOption], selectedOptions: [SelectedOption]) {
        openProductOptionsController(with: allOptions, selectedOptions: selectedOptions, delegate: self, onView: optionsContainerView)
    }
    
    private func updateNavigationBar() {
        addCartBarButton()
    }
    
    private func updateAddToCartButton() {
        productAddedToCart = true
        self.addToCartButton.setTitle(NSLocalizedString("Button.AddedToCart", comment: String()).uppercased(), for: .normal)
    }
    
    private func addProductToCart() {
        viewModel.addToCart
            .subscribe(onNext: { [weak self] success in
                if success {
                    self?.updateNavigationBar()
                    self?.updateAddToCartButton()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func openCartController() {
        showCartController()
    }
    
    // MARK: - actions    
    @IBAction func addToProductTapped(_ sender: UIButton) {
        if productAddedToCart {
            openCartController()
        } else {
            addProductToCart()
        }
    }
    
    @IBAction func quantityEditingDidBegin(_ sender: UITextField) {
        quantityUnderlineView.backgroundColor = UIColor.black
    }
    
    @IBAction func quantityEditingDidEnd(_ sender: UITextField) {
        quantityUnderlineView.backgroundColor = kQuantityUnderlineColorDefault
    }
    
    // MARK: - DetailImagesViewControllerProtocol
    func didTapImage(at index: Int) {
        if let product = viewModel.product.value {
            pushImageViewer(with: product, initialIndex: index)
        }
    }
    
    // MARK: - ProductOptionsControllerProtocol
    func didCalculate(collectionViewHeight: CGFloat) {
        optionsContainerViewHeightConstraint.constant = collectionViewHeight
    }
    
    func didSelectOption(with name: String, value: String) {
        viewModel.selectOption(with: name, value: value)
    }
    
    // MARK: - ErrorViewProtocol
    func didTapTryAgain() {
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imagesCarouselController = segue.destination as? ImagesCarouselViewController {
            imagesCarouselController.controllerDelegate = self
            detailImagesController = imagesCarouselController
        }
    }
}
