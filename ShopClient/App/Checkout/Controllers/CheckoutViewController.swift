//
//  CheckoutViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CheckoutCombinedDelegate: CheckoutShippingAddressAddCellDelegate, CheckoutShippingAddressEditCellDelegate, CheckoutPaymentAddCellDelegate, CheckoutCartTableViewCellDelegate, CheckoutCreditCardEditTableCellDelegate, CheckoutShippingOptionsEnabledTableCellDelegate, PaymentTypeViewControllerDelegate, CheckoutSelectedTypeTableCellDelegate, CheckoutBillingAddressEditCellDelegate, InputTextFieldViewDelegate {}

private let kPlaceOrderButtonColorEnabled = UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
private let kPlaceOrderButtonColorDisabled = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)

class CheckoutViewController: BaseViewController<CheckoutViewModel>, CheckoutCombinedDelegate {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var placeOrderButton: UIButton!
    
    fileprivate var destinationAddressType: AddressListType = .shipping
    fileprivate var tableProvider: CheckoutTableProvider!
    
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
    }
    
    private func setupTableView() {
        let cartCellName = String(describing: CheckoutCartTableViewCell.self)
        let cartNib = UINib(nibName: cartCellName, bundle: nil)
        tableView?.register(cartNib, forCellReuseIdentifier: cartCellName)
        
        let shippingAddressAddCellName = String(describing: CheckoutShippingAddressAddTableViewCell.self)
        let shippingAddressAddNib = UINib(nibName: shippingAddressAddCellName, bundle: nil)
        tableView.register(shippingAddressAddNib, forCellReuseIdentifier: shippingAddressAddCellName)
        
        let shippingAddressEditCellName = String(describing: CheckoutShippingAddressEditTableCell.self)
        let shippingAddressEditNib = UINib(nibName: shippingAddressEditCellName, bundle: nil)
        tableView.register(shippingAddressEditNib, forCellReuseIdentifier: shippingAddressEditCellName)
        
        let paymentAddCellName = String(describing: CheckoutPaymentAddTableViewCell.self)
        let paymentAddNib = UINib(nibName: paymentAddCellName, bundle: nil)
        tableView.register(paymentAddNib, forCellReuseIdentifier: paymentAddCellName)
        
        let paymentTypeCellName = String(describing: CheckoutSelectedTypeTableViewCell.self)
        let paymentTypeNib = UINib(nibName: paymentTypeCellName, bundle: nil)
        tableView?.register(paymentTypeNib, forCellReuseIdentifier: paymentTypeCellName)
        
        let paymentCreditCardEditCellName = String(describing: CheckoutCreditCardEditTableViewCell.self)
        let paymentCreditCardEditNib = UINib(nibName: paymentCreditCardEditCellName, bundle: nil)
        tableView.register(paymentCreditCardEditNib, forCellReuseIdentifier: paymentCreditCardEditCellName)
        
        let paymentBillingAddressEditCellName = String(describing: CheckoutBillingAddressEditTableViewCell.self)
        let paymentBillingAddressEditNib = UINib(nibName: paymentBillingAddressEditCellName, bundle: nil)
        tableView.register(paymentBillingAddressEditNib, forCellReuseIdentifier: paymentBillingAddressEditCellName)
        
        let shippingOptionsDisabledCellName = String(describing: CheckoutShippingOptionsDisabledTableViewCell.self)
        let shippingOptionsDisabledNib = UINib(nibName: shippingOptionsDisabledCellName, bundle: nil)
        tableView.register(shippingOptionsDisabledNib, forCellReuseIdentifier: shippingOptionsDisabledCellName)
        
        let shiippingOptionsEnabledCellName = String(describing: CheckoutShippingOptionsEnabledTableViewCell.self)
        let shiippingOptionsEnabledNib = UINib(nibName: shiippingOptionsEnabledCellName, bundle: nil)
        tableView.register(shiippingOptionsEnabledNib, forCellReuseIdentifier: shiippingOptionsEnabledCellName)
        
        let customerEmailCellName = String(describing: CustomerEmailTableViewCell.self)
        let customerEmailNib = UINib(nibName: customerEmailCellName, bundle: nil)
        tableView.register(customerEmailNib, forCellReuseIdentifier: customerEmailCellName)
        
        tableProvider = CheckoutTableProvider()
        tableProvider.delegate = self
        tableView.dataSource = tableProvider
        tableView.delegate = tableProvider
        
        tableView.contentInset = TableView.defaultContentInsets
    }
    
    private func setupViewModel() {
        viewModel.checkout.asObservable()
            .subscribe(onNext: { [weak self] checkout in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.tableProvider.checkout = checkout
                strongSelf.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.isCheckoutValid
            .subscribe(onNext: { [weak self] enabled in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.placeOrderButton.isEnabled = enabled
                strongSelf.placeOrderButton.backgroundColor = enabled ? kPlaceOrderButtonColorEnabled : kPlaceOrderButtonColorDisabled
            })
            .disposed(by: disposeBag)
        
        viewModel.checkoutSuccedded
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.performSegue(withIdentifier: SegueIdentifiers.toSuccessCheckout, sender: strongSelf)
            })
            .disposed(by: disposeBag)
        
        viewModel.cartItems.asObservable()
            .subscribe(onNext: { [weak self] cartProducts in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.tableProvider.cartProducts = cartProducts
            })
            .disposed(by: disposeBag)
        
        viewModel.customerHasEmail
            .subscribe(onNext: { [weak self] customerHasEmail in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.tableProvider.customerHasEmail = customerHasEmail
                strongSelf.reloadTable()
            })
            .disposed(by: disposeBag)
        
        viewModel.customerEmail.asObservable()
            .subscribe(onNext: { [weak self] email in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.tableProvider.customerEmail = email
            })
            .disposed(by: disposeBag)
        
        placeOrderButton.rx.tap
            .bind(to: viewModel.placeOrderPressed)
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.loadData()
    }
    
    private func closeAddressFormController() {
        navigationController?.popToViewController(self, animated: true)
    }
    
    fileprivate func reloadTable() {
        tableView?.reloadData()
    }
    
    fileprivate func openAddressesController(with type: AddressListType) {
        destinationAddressType = type
        if viewModel.customerLogged.value {
            performSegue(withIdentifier: SegueIdentifiers.toAddressList, sender: self)
        } else {
            performSegue(withIdentifier: SegueIdentifiers.toCheckoutAddressForm, sender: self)
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let productDetailsViewController = segue.destination as? ProductDetailsViewController {
            productDetailsViewController.productVariant = viewModel.selectedProductVariant
        } else if let addressListViewController = segue.destination as? AddressListViewController {
            addressListViewController.addressListType = destinationAddressType
            let isAddressTypeShipping = destinationAddressType == .shipping
            addressListViewController.selectedAddress = isAddressTypeShipping ? viewModel.checkout.value?.shippingAddress : viewModel.billingAddress.value
            addressListViewController.delegate = self
        } else if let paymentTypeViewController = segue.destination as? PaymentTypeViewController, let checkout = viewModel.checkout.value {
            paymentTypeViewController.checkout = checkout
            paymentTypeViewController.delegate = self
            paymentTypeViewController.selectedType = viewModel.selectedType.value
        } else if let navigationController = segue.destination as? NavigationController {
            if let checkoutSuccessViewController = navigationController.viewControllers.first as? CheckoutSuccessViewController, let orderId = viewModel.order?.id, let orderNumber = viewModel.order?.number {
                checkoutSuccessViewController.orderId = orderId
                checkoutSuccessViewController.orderNumber = orderNumber
            }
        } else if let creditCardFormController = segue.destination as? CreditCardViewController {
            creditCardFormController.card = viewModel.creditCard.value
            creditCardFormController.delegate = self
        } else if let checkoutAddressFormController = segue.destination as? CheckoutAddressFormViewController {
            checkoutAddressFormController.checkoutId = viewModel.checkout.value?.id
            checkoutAddressFormController.addressType = destinationAddressType
            checkoutAddressFormController.address = destinationAddressType == .shipping ? viewModel.checkout.value?.shippingAddress : viewModel.billingAddress.value
            checkoutAddressFormController.delegate = self
        }
    }
    
    // MARK: - InputTextFieldViewDelegate
    
    func textFieldView(_ view: InputTextFieldView, didEndUpdate text: String) {
        viewModel.customerEmail.value = text
        tableProvider.customerEmail = text
    }
}

// MARK: - CheckoutPaymentAddCellDelegate

extension CheckoutViewController: CheckoutPaymentAddCellDelegate {
    func tableViewCell(_ cell: CheckoutPaymentAddTableViewCell, didTapAdd paymentType: PaymentAddCellType) {
        switch paymentType {
        case PaymentAddCellType.type:
            performSegue(withIdentifier: SegueIdentifiers.toPaymentType, sender: self)
        case PaymentAddCellType.card:
            performSegue(withIdentifier: SegueIdentifiers.toCreditCard, sender: self)
        case PaymentAddCellType.billingAddress:
            openAddressesController(with: .billing)
        }
    }
}

// MARK: - CheckoutSelectedTypeTableCellDelegate

extension CheckoutViewController: CheckoutSelectedTypeTableCellDelegate {
    func tableViewCellDidTapEditPaymentType(_ cell: CheckoutSelectedTypeTableViewCell) {
        performSegue(withIdentifier: SegueIdentifiers.toPaymentType, sender: self)
    }
}

// MARK: - CheckoutCartTableViewCellDelegate

extension CheckoutViewController: CheckoutCartTableViewCellDelegate {
    func didSelectItem(with productVariantId: String, at index: Int) {
        viewModel.selectedProductVariant = viewModel.productVariant(with: productVariantId)
        performSegue(withIdentifier: SegueIdentifiers.toProductDetails, sender: self)
    }
}

// MARK: - CheckoutShippingAddressAddCellDelegate

extension CheckoutViewController: CheckoutShippingAddressAddCellDelegate {
    func tableViewCellDidTapAddNewAddress(_ cell: CheckoutShippingAddressAddTableViewCell) {
        openAddressesController(with: .shipping)
    }
}

// MARK: - CheckoutShippingOptionsEnabledTableCellDelegate

extension CheckoutViewController: CheckoutShippingOptionsEnabledTableCellDelegate {
    func tableViewCell(_ cell: CheckoutShippingOptionsEnabledTableViewCell, didSelect shippingRate: ShippingRate) {
        viewModel.updateShippingRate(with: shippingRate)
    }
}

// MARK: - PaymentTypeViewControllerDelegate

extension CheckoutViewController: PaymentTypeViewControllerDelegate {
    func viewController(_ viewController: PaymentTypeViewController, didSelect paymentType: PaymentType) {
        viewModel.selectedType.value = paymentType
        tableProvider.selectedPaymentType = paymentType
        reloadTable()
    }
}

// MARK: - CheckoutCreditCardEditTableCellDelegate

extension CheckoutViewController: CheckoutCreditCardEditTableCellDelegate {
    func tableViewCellDidTapEditCard(_ cell: CheckoutCreditCardEditTableViewCell) {
        performSegue(withIdentifier: SegueIdentifiers.toCreditCard, sender: self)
    }
}

// MARK: - CheckoutShippingAddressEditCellDelegate

extension CheckoutViewController: CheckoutShippingAddressEditCellDelegate {
    func tableViewCellDidTapEditShippingAddress(_ cell: CheckoutShippingAddressEditTableCell) {
        openAddressesController(with: .shipping)
    }
}

// MARK: - CheckoutBillingAddressEditCellDelegate

extension CheckoutViewController: CheckoutBillingAddressEditCellDelegate {
    func tableViewCellDidTapEditBillingAddress(_ cell: CheckoutBillingAddressEditTableViewCell) {
        openAddressesController(with: .billing)
    }
}

// MARK: - CheckoutAddressFormControllerDelegate

extension CheckoutViewController: CheckoutAddressFormControllerDelegate {
    func viewControllerDidUpdateShippingAddress(_ controller: CheckoutAddressFormViewController) {
        viewModel.getCheckout()
        navigationController?.popToViewController(self, animated: true)
    }
    
    func viewController(_ controller: CheckoutAddressFormViewController, didFill billingAddress: Address) {
        viewModel.billingAddress.value = billingAddress
        tableProvider.billingAddress = billingAddress
        reloadTable()
        navigationController?.popToViewController(self, animated: true)
    }
}

// MARK: - AddressListControllerDelegate

extension CheckoutViewController: AddressListControllerDelegate {
    func viewController(_ controller: AddressListViewController, didSelect address: Address) {
        if destinationAddressType == .shipping {
            viewModel.updateCheckoutShippingAddress(with: address)
        } else {
            viewModel.billingAddress.value = address
            tableProvider.billingAddress = address
            reloadTable()
        }
    }
}

// MARK: - CreditCardControllerDelegate

extension CheckoutViewController: CreditCardControllerDelegate {
    func viewController(_ controller: CreditCardViewController, didFilled card: CreditCard) {
        viewModel.creditCard.value = card
        tableProvider.creditCard = card
        reloadTable()
        navigationController?.popToViewController(self, animated: true)
    }
}
