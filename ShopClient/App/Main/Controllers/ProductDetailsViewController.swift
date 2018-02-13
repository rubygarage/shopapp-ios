//
//  DetailViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/5/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import TPKeyboardAvoiding

private let kQuantityUnderlineColorDefault = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
private let kBottomViewColorEnabled = UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
private let kBottomViewColorDisabled = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
private let kAddToCartChangesAnimationDuration: TimeInterval = 0.33
private let kProductDescriptionHeaderHeight = CGFloat(60.0)
private let kProductRelatedItemsHeight = CGFloat(291.0)
private let kProductDescriptionHiddenHeight = CGFloat(0.0)
private let kProductDescriptionAdditionalHeight = CGFloat(40.0)

typealias SelectedOption = (name: String, value: String)

class ProductDetailsViewController: BaseViewController<ProductDetailsViewModel> {
    @IBOutlet private weak var contentView: TPKeyboardAvoidingScrollView!
    @IBOutlet private weak var detailImagesContainer: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionStateImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var quantityTitleLabel: UILabel!
    @IBOutlet private weak var quantityTextField: UITextField!
    @IBOutlet private weak var quantityUnderlineView: UIView!
    @IBOutlet private weak var addToCartButton: UIButton!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var relatedItemsHeaderView: SeeAllTableHeaderView!
    @IBOutlet private weak var relatedItemsView: LastArrivalsTableViewCell!
    
    @IBOutlet private weak var descriptionContainerViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            descriptionContainerViewHeightConstraint.constant = kProductDescriptionHiddenHeight
        }
    }
    
    @IBOutlet fileprivate weak var optionsContainerViewHeightConstraint: NSLayoutConstraint!
    
    private var detailImagesController: ImagesCarouselViewController!
    private var productOptionsViewController: ProductOptionsViewController!
    
    var productId: String!
    var productVariant: ProductVariant!

    // MARK: - View controller lifecycle
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imagesCarouselController = segue.destination as? ImagesCarouselViewController {
            imagesCarouselController.delegate = self
            detailImagesController = imagesCarouselController
        } else if let productOptionsViewController = segue.destination as? ProductOptionsViewController {
            productOptionsViewController.delegate = self
            self.productOptionsViewController = productOptionsViewController
        } else if let productsListViewController = segue.destination as? ProductsListViewController {
            productsListViewController.title = "Label.RelatedItems".localizable
            productsListViewController.sortingValue = .type
            productsListViewController.keyPhrase = viewModel.product.value?.type
            productsListViewController.excludePhrase = viewModel.product.value?.title
        }
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        quantityTitleLabel.text = "Label.Quantity".localizable
        addToCartButton.setTitle("Button.AddToCart".localizable.uppercased(), for: .normal)
        addToCartButton.setTitle("Button.ProductTemporaryUnavailable".localizable.uppercased(), for: .disabled)
        relatedItemsHeaderView.delegate = self
        relatedItemsHeaderView.hideSeparator()
        relatedItemsView.delegate = self
    }
    
    private func setupViewModel() {
        viewModel.productId = productId
        viewModel.productVariant = productVariant
        
        quantityTextField.rx.text.map { Int($0 ?? "") ?? 1 }
            .bind(to: viewModel.quantity)
            .disposed(by: disposeBag)
        
        viewModel.product.asObservable()
            .subscribe(onNext: { [weak self] product in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.populateViews(product: product)
            })
            .disposed(by: disposeBag)
        
        viewModel.relatedItems.asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] products in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.populateRelatedItems(with: products)
            })
            .disposed(by: disposeBag)
        
        viewModel.selectedVariant
            .subscribe(onNext: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.updateOptionsViews(result: result)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.loadData()
    }
    
    private func populateViews(product: Product?) {
        guard let product = product else {
            return
        }
        populateImages(with: product)
        populateTitle(with: product)
        populateDescription(with: product)
    }
    
    private func populateImages(with product: Product) {
        guard let images = product.images, !images.isEmpty else {
            detailImagesContainer.isHidden = true
            return
        }
        detailImagesController.images = images
        detailImagesContainer.isHidden = false
    }
    
    private func populateTitle(with product: Product) {
        titleLabel.text = product.title
    }
    
    private func populateDescription(with product: Product) {
        descriptionLabel.text = product.productDescription
    }
    
    private func populateRelatedItems(with products: [Product]) {
        if products.count < kItemsPerPage {
            relatedItemsHeaderView.hideSeeAllButton()
        }
        relatedItemsView.configure(with: products)
    }
    
    private func updateOptionsViews(result: SelectedVariant) {
        populatePrice(variant: result.variant)
        populateAddToCartButton(variant: result.variant)
        populateOptionsView(allOptions: result.allOptions, selectedOptions: result.selectedOptions)
    }

    private func populatePrice(variant: ProductVariant?) {
        priceLabel.isHidden = variant == nil
        guard let variant = variant else {
            return
        }
        let formatter = NumberFormatter.formatter(with: viewModel.currency!)
        let price = NSDecimalNumber(decimal: variant.price ?? Decimal())
        priceLabel.text = formatter.string(from: price)
    }
    
    private func populateAddToCartButton(variant: ProductVariant?) {
        let variantAvailable = variant != nil
        addToCartButton.isEnabled = variantAvailable
        UIView.animate(withDuration: kAddToCartChangesAnimationDuration, animations: {
            self.bottomView.backgroundColor = variantAvailable ? kBottomViewColorEnabled : kBottomViewColorDisabled
        })
    }
    
    private func populateOptionsView(allOptions: [ProductOption], selectedOptions: [SelectedOption]) {
        productOptionsViewController.options = allOptions
        productOptionsViewController.selectedOptions = selectedOptions
    }

    private func updateNavigationBar() {
        addCartBarButton()
    }
    
    private func addProductToCart() {
        viewModel.addToCart
            .subscribe(onNext: { [weak self] success in
                guard let strongSelf = self, success else {
                    return
                }
                strongSelf.updateNavigationBar()
                strongSelf.showToast(with: "Alert.ProductAdded".localizable)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Actions
    
    @IBAction func addToCartButtonDidPress(_ sender: UIButton) {
        addProductToCart()
    }
    
    @IBAction func quantityEditingDidBegin(_ sender: UITextField) {
        quantityUnderlineView.backgroundColor = UIColor.black
    }
    
    @IBAction func quantityEditingDidEnd(_ sender: UITextField) {
        quantityUnderlineView.backgroundColor = kQuantityUnderlineColorDefault
    }
    
    @IBAction func descriptionContainerDidTap(_ sender: UITapGestureRecognizer) {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = navigationController?.navigationBar.frame.size.height ?? CGFloat(0.0)
        let barHeight = statusBarHeight + navigationBarHeight
        let contentOffsetY = self.contentView.contentSize.height - barHeight - kProductDescriptionHeaderHeight - kProductRelatedItemsHeight
        
        let image = descriptionContainerViewHeightConstraint.constant != kProductDescriptionHiddenHeight ? #imageLiteral(resourceName: "plus") : #imageLiteral(resourceName: "minus")
        
        let constant = descriptionContainerViewHeightConstraint.constant != kProductDescriptionHiddenHeight
            ? kProductDescriptionHiddenHeight
            : descriptionLabel.frame.size.height + kProductDescriptionAdditionalHeight
        
        descriptionContainerViewHeightConstraint.constant = constant
        
        UIView.animate(withDuration: kAddToCartChangesAnimationDuration, animations: {
            self.descriptionStateImageView.image = image
            self.contentView.contentOffset = CGPoint(x: 0.0, y: contentOffsetY)
            self.view.layoutIfNeeded()
        })
    }
}

// MARK: - ImagesCarouselViewControllerDelegate

extension ProductDetailsViewController: ImagesCarouselViewControllerDelegate {
    func viewController(_ viewController: ImagesCarouselViewController, didTapImageAt index: Int) {
        if let product = viewModel.product.value {
            pushImageViewer(with: product, initialIndex: index)
        }
    }
}

// MARK: - ProductOptionsControllerDelegate

extension ProductDetailsViewController: ProductOptionsControllerDelegate {
    func viewController(_ viewController: ProductOptionsViewController, didCalculate height: CGFloat) {
        optionsContainerViewHeightConstraint.constant = height
    }
    
    func viewController(_ viewController: ProductOptionsViewController, didSelect option: (name: String, value: String)) {
        viewModel.selectOption(with: option.name, value: option.value)
    }
}

// MARK: - SeeAllHeaderViewProtocol

extension ProductDetailsViewController: SeeAllHeaderViewProtocol {
    func didTapSeeAll(type: SeeAllViewType) {
        performSegue(withIdentifier: SegueIdentifiers.toProductsList, sender: self)
    }
}

// MARK: - LastArrivalsTableViewCellDelegate

extension ProductDetailsViewController: LastArrivalsTableCellDelegate {
    func tableViewCell(_ tableViewCell: LastArrivalsTableViewCell, didSelect product: Product) {
        guard let navigationController = navigationController else {
            return
        }
        let productDetailsViewController = UIStoryboard.main().instantiateViewController(withIdentifier: ControllerIdentifier.productDetails) as! ProductDetailsViewController
        productDetailsViewController.productId = product.id
        navigationController.pushViewController(productDetailsViewController, animated: true)
    }
}
