//
//  CheckoutViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import MFCard

class CheckoutViewController: BaseViewController<CheckoutViewModel>, AddressViewProtocol, CardValidationViewProtocol {
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var paymentByWebsiteView: UIView!
    @IBOutlet weak var paymentByWebsiteLabel: UILabel!
    @IBOutlet weak var paymentByWebsiteButton: UIButton!
    @IBOutlet weak var paymentByCardView: UIView!
    @IBOutlet weak var paymentByCardLabel: UILabel!
    @IBOutlet weak var paymentByCardButton: UIButton!
    @IBOutlet weak var paymentByApplePayView: UIView!
    @IBOutlet weak var paymentByApplePayLabel: UILabel!
    @IBOutlet weak var paymentByApplePayButton: UIButton!
    
    override func viewDidLoad() {
        viewModel = CheckoutViewModel()
        super.viewDidLoad()

        setupViews()
        populateViews()
        setupViewModel()
        loadData()
    }
    
    private func setupViews() {
        paymentByWebsiteView.addShadow()
        paymentByCardView.addShadow()
        paymentByApplePayView.addShadow()
    }
    
    private func populateViews() {
        title = NSLocalizedString("ControllerTitle.Checkout", comment: String())
        paymentMethodLabel.text = NSLocalizedString("Label.SelectPaymentMethod", comment: String())

        paymentByWebsiteLabel.text = NSLocalizedString("Label.PaymentMethodWebsite", comment: String())
        paymentByWebsiteButton.setTitle(NSLocalizedString("Button.PaymentMethodWebsite", comment: String()), for: .normal)
        
        paymentByCardLabel.text = NSLocalizedString("Label.PaymentMethodCard", comment: String())
        paymentByCardButton.setTitle(NSLocalizedString("Button.PaymentMethodCard", comment: String()), for: .normal)
        
        paymentByApplePayLabel.text = NSLocalizedString("Label.PaymentMethodApplePay", comment: String())
        paymentByApplePayButton.setTitle(NSLocalizedString("Button.PaymentMethodApplePay", comment: String()), for: .normal)
    }
    
    private func setupViewModel() {
        viewModel.paymentSuccess
            .subscribe(onNext: { success in
                // TODO:
            })
            .disposed(by: disposeBag)
        
        viewModel.availableRates.asObservable()
            .subscribe(onNext: { [weak self] rates in
                if rates.count > 0 {
                    self?.showAvailableRatesView(with: rates)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.rateUpdatingSuccess
            .subscribe(onNext: { [weak self] success in
                if success {
                    self?.showPriceInfoAlert()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.loadData(with: disposeBag)
    }
    
    private func openBrowserIfNeeded(with link: URL) {
        if UIApplication.shared.canOpenURL(link) {
            UIApplication.shared.open(link, options: [:])
        }
    }
    
    // MARK: - actions
    @IBAction func payWebsiteTapped(_ sender: UIButton) {
        if let link = URL(string: viewModel.checkout?.webUrl ?? String()) {
            openBrowserIfNeeded(with: link)
        }
    }
    
    @IBAction func paymentCardTapped(_ sender: UIButton) {
        showAddressController(with: self)
    }
    
    // MARK: - AddressViewProtocol
    func didFilled(address: Address) {
        viewModel.getShippingRates(with: address)
    }
    
    // MARK: - CardValidationViewProtocol
    func didCardFilled(with card: CreditCard?, errorMessage: String?) {
        if let creditCard = card {
            viewModel.pay(with: creditCard)
        } else if let error = errorMessage {
            showToast(with: error)
        }
    }
    
    // MARK: - ErrorViewProtocol
    func didTapTryAgain() {
        viewModel.loadData(with: disposeBag)
    }
}

internal extension CheckoutViewController {
    func showAvailableRatesView(with rates: [ShippingRate]) {
        let title = NSLocalizedString("Alert.ChooseShippingRate", comment: String())
        let currency = viewModel.currency ?? String()
        let buttons = rates.map({ item -> String in
            let title = item.title ?? String()
            let price = item.price ?? String()
            return "\(title) (\(price) \(currency))"
        })
        let cancel = NSLocalizedString("Button.Cancel", comment: String())
        showActionSheet(with: title, buttons: buttons, cancel: cancel) { [weak self] (index) in
            if index < rates.count {
                self?.viewModel.updateCheckout(with: rates[index])
            }
        }
    }
    
    func showPriceInfoAlert() {
        let title = NSLocalizedString("Alert.PriceInfo", comment: String())
        let submit = NSLocalizedString("Button.Continue", comment: String())
        
        let totalPrice = ((viewModel.checkout?.totalPrice?.description ?? String()) as NSString).floatValue
        let productsPrice = ((viewModel.checkout?.subtotalPrice?.description ?? String()) as NSString).floatValue
        let taxPrice = ((viewModel.checkout?.totalTax?.description ?? String()) as NSString).floatValue
        let deliveryPrice = totalPrice - productsPrice
        let currency = viewModel.currency ?? String()
        
        let productsPriceSubstring = NSLocalizedString("Label.PriceOfProducts", comment: String())
        let productsPriceString = String.localizedStringWithFormat(productsPriceSubstring, productsPrice, currency)
        
        let deliveryPriceSubstring = NSLocalizedString("Label.PriceOfDelivery", comment: String())
        let deiveryPriceString = String.localizedStringWithFormat(deliveryPriceSubstring, deliveryPrice, currency)
        
        let totalTaxSubstring = NSLocalizedString("Label.TotalTax", comment: String())
        let totalTaxString = String.localizedStringWithFormat(totalTaxSubstring, taxPrice, currency)
        
        let totalPriceSubstring = NSLocalizedString("Label.TotalPrice", comment: String())
        let totalPriceString = String.localizedStringWithFormat(totalPriceSubstring, totalPrice, currency)
        
        let priceInfoLocalizedString = NSLocalizedString("Label.PriceInfo", comment: String())
        
        let message = String.localizedStringWithFormat(priceInfoLocalizedString, productsPriceString, deiveryPriceString, totalTaxString, totalPriceString)
        showAlert(with: title, message: message, submit: submit) { (index) in
            if index == .submit {
                let cardView = CardValidationView(delegate: self)
                cardView.show()
            }
        }
    }
}
