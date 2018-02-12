//
//  PlaceholderedTextField.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 2/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

private let kPlaceholderAnimationDuration: TimeInterval = 0.15
private let kPlaceholderPositionTopY: CGFloat = -25
private let kPlaceholderFontSizeTop: CGFloat = 11
private let kPlaceholderFontSizeDefault: CGFloat = 12
private let kPlaceholderColorTop = UIColor.black.withAlphaComponent(0.5)

class PlaceholderedTextField: TextFieldWrapper {
    // swiftlint:disable private_outlet
    @IBOutlet fileprivate(set) weak var placeholderLabel: UILabel!
    @IBOutlet fileprivate(set) weak var placeholderVerticallyConstraint: NSLayoutConstraint!
    // swiftlint:enable private_outlet
    
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    // MARK: - Setup
    
    func setPlaceholderPosition() {
        let toTop = text?.isEmpty == false
        updatePlaceholderPosition(toTop: toTop, animated: false)
    }
    
    func updatePlaceholderPosition(toTop: Bool, animated: Bool) {
        let animationDuration = animated ? kPlaceholderAnimationDuration : 0
        let placeholderVerticalPosition: CGFloat = toTop ? kPlaceholderPositionTopY : 0
        placeholderVerticallyConstraint?.constant = placeholderVerticalPosition
        let fontSize = toTop ? kPlaceholderFontSizeTop : kPlaceholderFontSizeDefault
        self.placeholderLabel.font = .systemFont(ofSize: fontSize)
        
        UIView.animate(withDuration: animationDuration) {
            self.layoutIfNeeded()
        }
        
        UIView.transition(with: placeholderLabel, duration: animationDuration, options: .transitionCrossDissolve, animations: {
            self.placeholderLabel?.textColor = toTop ? kPlaceholderColorTop : .black
        })
    }
}
