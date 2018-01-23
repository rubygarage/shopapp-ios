//
//  CheckoutSuccessViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

private let kOrderNumberColor = UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)

class CheckoutSuccessViewController: BaseViewController<CheckoutSuccessViewModel> {
    @IBOutlet private weak var thanksForShoppingLabel: UILabel!
    @IBOutlet private weak var orderNumberLabel: UILabel!
    @IBOutlet private weak var viewOrderDetailsButton: BlackButton!
    @IBOutlet private weak var continueShoppingButton: UnderlinedButton!
    
    var orderId: String!
    var orderNumber: Int = 0
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = CheckoutSuccessViewModel()
        super.viewDidLoad()

        setupViews()
    }
    
    // MARK: - Setup
    private func setupViews() {
        thanksForShoppingLabel?.text = "Label.ThanksForShopping".localizable
        orderNumberLabel?.setup(with: orderNumber)
        viewOrderDetailsButton?.setTitle("Button.ViewOrderDetails".localizable.uppercased(), for: .normal)
        continueShoppingButton?.setTitle("Button.ContinueShopping".localizable.uppercased(), for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func viewOrderDetailsTapped(_ sender: BlackButton) {
        // TODO:
    }
    
    @IBAction func continueShoppingTapped(_ sender: UnderlinedButton) {
        // TODO:
    }
}

fileprivate extension UILabel {
    func setup(with orderNumber: Int) {
        let orderNumberLocalizable = "Label.YourOrderNumber".localizable
        let orderNumberLocalized = String.localizedStringWithFormat(orderNumberLocalizable, String(orderNumber))
        let attributed = NSMutableAttributedString(string: orderNumberLocalized)
        let highlightedText = String(orderNumber)
        let range = (orderNumberLocalized as NSString).range(of: highlightedText)
        attributed.addAttribute(NSForegroundColorAttributeName, value: kOrderNumberColor, range: range)
        attributedText = attributed
    }
}
