//
//  CheckoutSuccessViewController.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 1/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

private let kOrderNumberColor = UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)

class CheckoutSuccessViewController: UIViewController, UnderlinedButtonDelegate {
    @IBOutlet private weak var thanksForShoppingLabel: UILabel!
    @IBOutlet private weak var orderNumberLabel: UILabel!
    @IBOutlet private weak var viewOrderDetailsButton: BlackButton!
    @IBOutlet private weak var continueShoppingButton: UnderlinedButton!
    
    @IBOutlet fileprivate weak var continueShoppingUnderlineView: UIView!
    
    var orderId: String!
    var orderNumber: Int = 0
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        title = "ControllerTitle.Home".localizable
        thanksForShoppingLabel?.text = "Label.ThanksForShopping".localizable
        orderNumberLabel?.setup(with: orderNumber)
        viewOrderDetailsButton?.setTitle("Button.ViewOrderDetails".localizable.uppercased(), for: .normal)
        continueShoppingButton?.setTitle("Button.ContinueShopping".localizable.uppercased(), for: .normal)
        continueShoppingButton.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func continueShoppingTapped(_ sender: UnderlinedButton) {
        setHomeController()
        dismissModalStack()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let orderDetailsViewController = segue.destination as? OrderDetailsViewController {
            orderDetailsViewController.orderId = orderId
        }
    }
    
    // MARK: - UnderlinedButtonDelegate
    
    func underlinedButton(_ button: UnderlinedButton, didChangeState isHighlighted: Bool) {
        continueShoppingUnderlineView.isHidden = isHighlighted
    }
}

fileprivate extension UILabel {
    func setup(with orderNumber: Int) {
        let orderNumberLocalizable = "Label.YourOrderNumber".localizable
        let orderNumberLocalized = String.localizedStringWithFormat(orderNumberLocalizable, String(orderNumber))
        let attributed = NSMutableAttributedString(string: orderNumberLocalized)
        let highlightedText = String(orderNumber)
        let range = (orderNumberLocalized as NSString).range(of: highlightedText)
        attributed.addAttribute(NSAttributedString.Key.foregroundColor, value: kOrderNumberColor, range: range)
        attributedText = attributed
    }
}
