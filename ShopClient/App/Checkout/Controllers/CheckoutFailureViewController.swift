//
//  CheckoutFailureViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol CheckoutFailureViewControllerDelegate: class {
    func viewControllerDidTapTryAgain(_ controller: CheckoutFailureViewController)
}

class CheckoutFailureViewController: UIViewController {
    @IBOutlet private weak var somethingHappendLabel: UILabel!
    @IBOutlet private weak var purchaseErrorLabel: UILabel!
    @IBOutlet private weak var tryAgainButton: BlackButton!
    @IBOutlet private weak var backToShopButton: UnderlinedButton!
    
    @IBOutlet fileprivate weak var backToShopUnderlineView: UIView!
    
    weak var delegate: CheckoutFailureViewControllerDelegate?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        title = "ControllerTitle.Home".localizable
        somethingHappendLabel.text = "Label.SomethingHappened".localizable
        purchaseErrorLabel.text = "Label.PurchaseCouldntBeCompleted".localizable
        tryAgainButton.setTitle("Button.TryAgain".localizable.uppercased(), for: .normal)
        backToShopButton.setTitle("Button.BackToShop".localizable.uppercased(), for: .normal)
        backToShopButton.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func tryAgainButtonDidPress(_ sender: BlackButton) {
        dismiss(animated: true) {
            self.delegate?.viewControllerDidTapTryAgain(self)
        }
    }
    
    @IBAction func backToShopButtonDidPress(_ sender: UnderlinedButton) {
        setHomeController()
        dismissModalStack()
    }
}

// MARK: - UnderlinedButtonDelegate

extension CheckoutFailureViewController: UnderlinedButtonDelegate {
    func underlinedButton(_ button: UnderlinedButton, didChangeState isHighlighted: Bool) {
        backToShopUnderlineView.isHidden = isHighlighted
    }
}
