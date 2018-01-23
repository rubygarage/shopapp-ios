//
//  CheckoutViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

private let kPlaceOrderHeightVisible: CGFloat = 50
private let kPlaceOrderHeightInvisible: CGFloat = 0

class CheckoutViewController: BaseViewController<CheckoutViewModel>, SeeAllHeaderViewProtocol, CheckoutCombinedProtocol {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var placeOrderHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var placeOrderButton: UIButton!
    
    private var tableDataSource: CheckoutTableDataSource!
    // swiftlint:disable weak_delegate
    private var tableDelegate: CheckoutTableDelegate!
    // swiftlint:enable weak_delegate
    private var destinationAddress: Address?
    private var selectedProductVariant: ProductVariant!
    
    override func viewDidLoad() {
        viewModel = CheckoutViewModel()
        super.viewDidLoad()

        setupViews()
        setupTableView()
        setupViewModel()
        loadData()
    }
    
    private func setupViews() {
        addCloseButton()
        title = "ControllerTitle.Checkout".localizable
        placeOrderButton.setTitle("Button.PlaceOrder".localizable.uppercased(), for: .normal)
        updatePlaceOrderButtonUI()
    }
    
    private func setupTableView() {
        let cartNib = UINib(nibName: String(describing: CheckoutCartTableViewCell.self), bundle: nil)
        tableView?.register(cartNib, forCellReuseIdentifier: String(describing: CheckoutCartTableViewCell.self))
        
        let shippingAddressAddNib = UINib(nibName: String(describing: CheckoutShippingAddressAddTableCell.self), bundle: nil)
        tableView.register(shippingAddressAddNib, forCellReuseIdentifier: String(describing: CheckoutShippingAddressAddTableCell.self))
        
        let shippingAddressEditNib = UINib(nibName: String(describing: CheckoutShippingAddressEditTableCell.self), bundle: nil)
        tableView.register(shippingAddressEditNib, forCellReuseIdentifier: String(describing: CheckoutShippingAddressEditTableCell.self))
        
        let paymentAddNib = UINib(nibName: String(describing: CheckoutPaymentAddTableCell.self), bundle: nil)
        tableView.register(paymentAddNib, forCellReuseIdentifier: String(describing: CheckoutPaymentAddTableCell.self))
        
        let paymentEditNib = UINib(nibName: String(describing: CheckoutPaymentEditTableCell.self), bundle: nil)
        tableView.register(paymentEditNib, forCellReuseIdentifier: String(describing: CheckoutPaymentEditTableCell.self))
        
        let shiippingOptionsDisabledNib = UINib(nibName: String(describing: CheckoutShippingOptionsDisabledTableCell.self), bundle: nil)
        tableView.register(shiippingOptionsDisabledNib, forCellReuseIdentifier: String(describing: CheckoutShippingOptionsDisabledTableCell.self))
        
        let shiippingOptionsEnabledNib = UINib(nibName: String(describing: CheckoutShippingOptionsEnabledTableCell.self), bundle: nil)
        tableView.register(shiippingOptionsEnabledNib, forCellReuseIdentifier: String(describing: CheckoutShippingOptionsEnabledTableCell.self))
        
        tableDataSource = CheckoutTableDataSource()
        tableDataSource.delegate = self
        tableView?.dataSource = tableDataSource
        
        tableDelegate = CheckoutTableDelegate()
        tableDelegate.delegate = self
        tableView?.delegate = tableDelegate
        
        tableView?.contentInset = TableView.defaultContentInsets
    }
    
    private func setupViewModel() {
        viewModel.checkout.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
                self?.updatePlaceOrderButtonUI()
            })
            .disposed(by: disposeBag)
        
        viewModel.checkoutSuccedded
            .subscribe(onNext: { [weak self] _ in
                self?.performSegue(withIdentifier: SegueIdentifiers.toSuccessCheckout, sender: self)
            })
            .disposed(by: disposeBag)
        
        placeOrderButton.rx.tap
            .bind(to: viewModel.placeOrderPressed)
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.loadData(with: disposeBag)
    }
    
    private func closeAddressFormController() {
        navigationController?.popToViewController(self, animated: true)
    }
    
    // MARK: - CheckoutTableDataSourceProtocol
    
    func cartProducts() -> [CartProduct] {
        return viewModel.cartItems
    }
    
    func shippingAddress() -> Address? {
        return viewModel.checkout.value?.shippingAddress
    }
    
    func billingAddress() -> Address? {
        return viewModel.billingAddress
    }
    
    func creditCard() -> CreditCard? {
        return viewModel.creditCard
    }
    
    func availableShippingRates() -> [ShippingRate]? {
        return viewModel.checkout.value?.availableShippingRates
    }
    
    // MARK: - CheckoutShippingAddressAddCellProtocol
    
    func didTapAddNewAddress() {
        performSegue(withIdentifier: SegueIdentifiers.toAddressForm, sender: self)
    }
    
    // MARK: - CheckoutShippingAddressEditCellProtocol
    
    func didTapEdit() {
        if let checkoutId = viewModel.checkout.value?.id, let address = viewModel.checkout.value?.shippingAddress {
            processUpdateAddress(with: checkoutId, address: address)
        }
    }
    
    // MARK: - Private
    
    private func processUpdateAddress(with checkoutId: String, address: Address) {
        if Repository.shared.isLoggedIn() {
            openAddressList(with: checkoutId, address: address)
        } else {
            openAddressForm(with: address)
        }
    }
    
    private func openAddressList(with checkoutId: String, address: Address) {
        destinationAddress = address
        performSegue(withIdentifier: SegueIdentifiers.toAddressList, sender: self)
    }
    
    private func openAddressForm(with address: Address) {
        performSegue(withIdentifier: SegueIdentifiers.toAddressForm, sender: self)
    }
    
    private func updatePlaceOrderButtonUI() {
        let visible = viewModel.checkout.value != nil && viewModel.creditCard != nil && viewModel.billingAddress != nil && viewModel.checkout.value?.shippingLine != nil
        placeOrderButton.isHidden = !visible
        placeOrderHeightConstraint.constant = visible ? kPlaceOrderHeightVisible : kPlaceOrderHeightInvisible
    }
    
    private func returnFlowToSelf() {
        navigationController?.popToViewController(self, animated: true)
    }
    
    // MARK: - SeeAllHeaderViewProtocol
    
    func didTapSeeAll(type: SeeAllViewType) {
        if type == .myCart {
            // TODO:
        }
    }
    
    // MARK: - CheckoutPaymentAddCellProtocol
    
    func didTapAddPayment() {
        performSegue(withIdentifier: SegueIdentifiers.toPaymentType, sender: self)
    }
    
    // MARK: - CheckoutPaymentEditTableCellProtocol
    
    func didTapEditPaymentType() {
        performSegue(withIdentifier: SegueIdentifiers.toPaymentType, sender: self)
    }
    
    // MARK: - CheckoutTableDelegateProtocol
    
    func checkout() -> Checkout? {
        return viewModel.checkout.value
    }
    
    // MARK: - CheckoutCartTableViewCellDelegate
    
    func didSelectItem(with productVariantId: String, at index: Int) {
        selectedProductVariant = viewModel.productVariant(with: productVariantId)
        performSegue(withIdentifier: SegueIdentifiers.toProductDetails, sender: self)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let productDetailsViewController = segue.destination as? ProductDetailsViewController {
            productDetailsViewController.productVariant = selectedProductVariant
        } else if let addressListViewController = segue.destination as? AddressListViewController {
            addressListViewController.addressListType = .shipping
            addressListViewController.selectedAddress = destinationAddress
            addressListViewController.completion = { [weak self] (address) in
                self?.navigationController?.popViewController(animated: true)
                self?.viewModel.updateCheckoutShippingAddress(with: address, isDefaultAddress: false)
            }
        } else if let addressFormViewController = segue.destination as? AddressFormViewController {
            addressFormViewController.completion = { [weak self] (address, isDefaultAddress) in
                self?.viewModel.updateCheckoutShippingAddress(with: address, isDefaultAddress: isDefaultAddress)
            }
        } else if let paymentTypeViewController = segue.destination as? PaymentTypeViewController, let checkout = viewModel.checkout.value {
            paymentTypeViewController.checkout = checkout
            paymentTypeViewController.creditCardCompletion = { [weak self] (billingAddress, card) in
                self?.viewModel.billingAddress = billingAddress
                self?.viewModel.creditCard = card
                self?.tableView.reloadData()
                self?.updatePlaceOrderButtonUI()
                self?.returnFlowToSelf()
            }
        } else if let checkoutSuccessViewController = segue.destination as? CheckoutSuccessViewController {
            if let orderId = viewModel.order?.id, let orderNumber = viewModel.order?.number {
                checkoutSuccessViewController.orderId = orderId
                checkoutSuccessViewController.orderNumber = orderNumber
            }
        }
    }
}

// MARK: - CheckoutShippingOptionsEnabledTableCellProtocol

extension CheckoutViewController: CheckoutShippingOptionsEnabledTableCellProtocol {
    func didSelect(shippingRate: ShippingRate) {
        viewModel.updateShippingRate(with: shippingRate)
    }
}
