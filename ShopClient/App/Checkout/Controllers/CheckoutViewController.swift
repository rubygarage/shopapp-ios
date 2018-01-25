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

class CheckoutViewController: BaseViewController<CheckoutViewModel>, CheckoutCombinedProtocol {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var placeOrderHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var placeOrderButton: UIButton!
    
    private var tableDataSource: CheckoutTableDataSource!
    // swiftlint:disable weak_delegate
    private var tableDelegate: CheckoutTableDelegate!
    // swiftlint:enable weak_delegate
    private var destinationAddressType: AddressListType = .shipping
    
    fileprivate var selectedProductVariant: ProductVariant!
    fileprivate var selectedType: PaymentTypeSection?
    
    override func viewDidLoad() {
        viewModel = CheckoutViewModel()
        super.viewDidLoad()

        setupViews()
        setupTableView()
        setupViewModel()
        loadData()
    }
    
    // MARK: - Setup
    
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
        
        let paymentTypeNib = UINib(nibName: String(describing: CheckoutSelectedTypeTableCell.self), bundle: nil)
        tableView?.register(paymentTypeNib, forCellReuseIdentifier: String(describing: CheckoutSelectedTypeTableCell.self))
        
        let paymentCreditCardEditNib = UINib(nibName: String(describing: CheckoutCreditCardEditTableCell.self), bundle: nil)
        tableView.register(paymentCreditCardEditNib, forCellReuseIdentifier: String(describing: CheckoutCreditCardEditTableCell.self))
        
        let paymentBillingAddressEditNib = UINib(nibName: String(describing: CheckoutBillingAddressEditTableCell.self), bundle: nil)
        tableView.register(paymentBillingAddressEditNib, forCellReuseIdentifier: String(describing: CheckoutBillingAddressEditTableCell.self))
        
        let shiippingOptionsDisabledNib = UINib(nibName: String(describing: CheckoutShippingOptionsDisabledTableCell.self), bundle: nil)
        tableView.register(shiippingOptionsDisabledNib, forCellReuseIdentifier: String(describing: CheckoutShippingOptionsDisabledTableCell.self))
        
        let shiippingOptionsEnabledNib = UINib(nibName: String(describing: CheckoutShippingOptionsEnabledTableCell.self), bundle: nil)
        tableView.register(shiippingOptionsEnabledNib, forCellReuseIdentifier: String(describing: CheckoutShippingOptionsEnabledTableCell.self))
        
        tableDataSource = CheckoutTableDataSource()
        tableDataSource.delegate = self
        tableView?.dataSource = tableDataSource
        
        tableDelegate = CheckoutTableDelegate()
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
    
    // MARK: - Private
    
    private func loadData() {
        viewModel.loadData(with: disposeBag)
    }
    
    private func closeAddressFormController() {
        navigationController?.popToViewController(self, animated: true)
    }
    
    private func updatePlaceOrderButtonUI() {
        let visible = viewModel.checkout.value != nil && viewModel.creditCard != nil && viewModel.billingAddress != nil && viewModel.checkout.value?.shippingLine != nil
        placeOrderButton.isHidden = !visible
        placeOrderHeightConstraint.constant = visible ? kPlaceOrderHeightVisible : kPlaceOrderHeightInvisible
    }
    
    private func returnFlowToSelf() {
        navigationController?.popToViewController(self, animated: true)
    }
    
    private func shippingAddressCompletion() -> AddressListCompletion {
        return { [weak self] (address) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.navigationController?.popViewController(animated: true)
            strongSelf.viewModel.updateCheckoutShippingAddress(with: address, isDefaultAddress: false)
        }
    }
    
    private func billingAddressCompletion() -> AddressListCompletion {
        return { [weak self] (address) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel.billingAddress = address
            strongSelf.reloadTable()
            strongSelf.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Fileprivate
    
    fileprivate func reloadTable() {
        tableView?.reloadData()
    }
    
    fileprivate func openAddressesController(with type: AddressListType) {
        destinationAddressType = type
        viewModel.getLoginStatus { (isLogged) in
            if isLogged {
                performSegue(withIdentifier: SegueIdentifiers.toAddressList, sender: self)
            } else {
                performSegue(withIdentifier: SegueIdentifiers.toAddressForm, sender: self)
            }
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let productDetailsViewController = segue.destination as? ProductDetailsViewController {
            productDetailsViewController.productVariant = selectedProductVariant
        } else if let addressListViewController = segue.destination as? AddressListViewController {
            addressListViewController.addressListType = destinationAddressType
            let isAddressTypeShipping = destinationAddressType == .shipping
            addressListViewController.selectedAddress = isAddressTypeShipping ? shippingAddress() : billingAddress()
            addressListViewController.completion = isAddressTypeShipping ? shippingAddressCompletion() : billingAddressCompletion()
        } else if let addressFormViewController = segue.destination as? AddressFormViewController {
            addressFormViewController.address = viewModel.billingAddress
            addressFormViewController.completion = { [weak self] (address, isDefaultAddress) in
                self?.viewModel.updateCheckoutShippingAddress(with: address, isDefaultAddress: isDefaultAddress)
            }
        } else if let paymentTypeViewController = segue.destination as? PaymentTypeViewController, let checkout = viewModel.checkout.value {
            paymentTypeViewController.checkout = checkout
            paymentTypeViewController.delegate = self
            paymentTypeViewController.selectedType = selectedType
        } else if let navigationController = segue.destination as? NavigationController {
            if let checkoutSuccessViewController = navigationController.viewControllers.first as? CheckoutSuccessViewController, let orderId = viewModel.order?.id, let orderNumber = viewModel.order?.number {
                checkoutSuccessViewController.orderId = orderId
                checkoutSuccessViewController.orderNumber = orderNumber
            }
        } else if let creditCardFormController = segue.destination as? CreditCardViewController {
            creditCardFormController.card = viewModel.creditCard
            creditCardFormController.completion = { [weak self] (card) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.viewModel.creditCard = card
                strongSelf.reloadTable()
                strongSelf.updatePlaceOrderButtonUI()
                strongSelf.returnFlowToSelf()
            }
        }
    }
}

// MARK: - CheckoutPaymentAddCellProtocol

extension CheckoutViewController: CheckoutPaymentAddCellProtocol {
    func didTapAddPayment(type: PaymentTypeRow) {
        switch type {
        case PaymentTypeRow.type:
            performSegue(withIdentifier: SegueIdentifiers.toPaymentType, sender: self)
        case PaymentTypeRow.card:
            performSegue(withIdentifier: SegueIdentifiers.toCreditCard, sender: self)
        case PaymentTypeRow.billingAddress:
            openAddressesController(with: .billing)
        }
    }
}

// MARK: - CheckoutSelectedTypeTableCellProtocol

extension CheckoutViewController: CheckoutSelectedTypeTableCellProtocol {
    func didTapEditPaymentType() {
        performSegue(withIdentifier: SegueIdentifiers.toPaymentType, sender: self)
    }
}

// MARK: - CheckoutTableDelegateProtocol

extension CheckoutViewController: CheckoutTableDelegateProtocol {
    func checkout() -> Checkout? {
        return viewModel.checkout.value
    }
}

// MARK: - CheckoutCartTableViewCellDelegate

extension CheckoutViewController: CheckoutCartTableViewCellDelegate {
    func didSelectItem(with productVariantId: String, at index: Int) {
        selectedProductVariant = viewModel.productVariant(with: productVariantId)
        performSegue(withIdentifier: SegueIdentifiers.toProductDetails, sender: self)
    }
}

// MARK: - CheckoutTableDataSourceProtocol

extension CheckoutViewController: CheckoutTableDataSourceProtocol {
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
    
    func selectedPaymentType() -> PaymentTypeSection? {
        return selectedType
    }
}

// MARK: - CheckoutShippingAddressAddCellProtocol

extension CheckoutViewController: CheckoutShippingAddressAddCellProtocol {
    func didTapAddNewAddress() {
        performSegue(withIdentifier: SegueIdentifiers.toAddressForm, sender: self)
    }
}

// MARK: - CheckoutShippingAddressEditCellProtocol

extension CheckoutViewController: CheckoutShippingAddressEditCellProtocol {
    func didTapEdit() {
        openAddressesController(with: .shipping)
    }
}

// MARK: - CheckoutShippingOptionsEnabledTableCellProtocol

extension CheckoutViewController: CheckoutShippingOptionsEnabledTableCellProtocol {
    func didSelect(shippingRate: ShippingRate) {
        viewModel.updateShippingRate(with: shippingRate)
    }
}

// MARK: - PaymentTypeViewControllerProtocol

extension CheckoutViewController: PaymentTypeViewControllerProtocol {
    func didSelect(paymentType: PaymentTypeSection) {
        selectedType = paymentType
        reloadTable()
    }
}

// MARK: - CheckoutCreditCardEditTableCellProtocol

extension CheckoutViewController: CheckoutCreditCardEditTableCellProtocol {
    func didTapEditCard() {
        performSegue(withIdentifier: SegueIdentifiers.toCreditCard, sender: self)
    }
}

// MARK: - CheckoutBillingAddressEditTableCellProtocol

extension CheckoutViewController: CheckoutBillingAddressEditTableCellProtocol {
    func didTapEditBillingAddress() {
        openAddressesController(with: .billing)
    }
}
