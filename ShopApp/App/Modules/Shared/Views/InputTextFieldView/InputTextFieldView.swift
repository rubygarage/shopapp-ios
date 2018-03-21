//
//  InputTextFieldView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

enum InputTextFieldViewState: Int {
    case normal
    case highlighted
    case error
}

enum InputTextFieldViewKeybordType: Int {
    case email      // 0
    case password   // 1
    case name       // 2
    case phone      // 3
    case zip        // 4
    case `default`  // 5
    case cardNumber // 6
    case cvv        // 7
}

@objc protocol InputTextFieldViewDelegate: class {
    @objc optional func textFieldView(_ view: InputTextFieldView, didEndUpdate text: String)
    @objc optional func textFieldView(_ view: InputTextFieldView, didUpdate text: String)
}

class InputTextFieldView: PlaceholderedTextField, UITextFieldDelegate {
    @IBOutlet private weak var underlineView: UIView!
    @IBOutlet private weak var underlineViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var errorMessageLabel: UILabel!
    @IBOutlet private weak var showPasswordButton: UIButton!
    
    @IBInspectable var keyboardType: Int = InputTextFieldViewKeybordType.name.rawValue {
        didSet {
            setupKeyboardType(with: keyboardType)
            setupKeyboardSecureTextEntry(with: keyboardType)
            setupKeyboardCapitalization(with: keyboardType)
        }
    }
    @IBInspectable var hideShowPasswordButton: Bool = true {
        didSet {
            setupKeyboardSecureTextEntry(with: keyboardType)
        }
    }
    
    private let underlineViewAlphaDefault: CGFloat = 0.2
    private let underlineViewAlphaHighlighted: CGFloat = 1
    private let underlineViewHeightDefault: CGFloat = 1
    private let underlineViewHeightHighlighted: CGFloat = 2
    private let errorColor = UIColor(displayP3Red: 0.89, green: 0.31, blue: 0.31, alpha: 1)
    
    weak var delegate: InputTextFieldViewDelegate?
    
    override var text: String? {
        didSet {
            setPlaceholderPosition()
        }
    }
    var state: InputTextFieldViewState = .normal {
        didSet {
            updateUI()
        }
    }
    var errorMessage: String? {
        didSet {
            state = .error
            errorMessageLabel.text = errorMessage
            updateUI()
        }
    }
    
    // MARK: - View lifecycle
    
    init() {
        super.init(frame: CGRect.zero)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    // MARK: - Setup
    
    private func commonInit() {
        loadFromNib()

        textField?.delegate = self
        setupViews()
        updateUI()
    }
    
    private func setupViews() {
        backgroundColor = UIColor.clear
        errorMessageLabel.textColor = errorColor
    }
    
    private func updateUI() {
        underlineView.alpha = state == .normal ? underlineViewAlphaDefault : underlineViewAlphaHighlighted
        underlineViewHeightConstraint.constant = state == .normal ? underlineViewHeightDefault : underlineViewHeightHighlighted
        underlineView.backgroundColor = state == .error ? errorColor : UIColor.black
        errorMessageLabel.isHidden = state != .error
    }
    
    private func setupKeyboardType(with type: Int) {
        let type: UIKeyboardType
        switch keyboardType {
        case InputTextFieldViewKeybordType.email.rawValue:
            type = .emailAddress
        case InputTextFieldViewKeybordType.phone.rawValue:
            type = .phonePad
        case InputTextFieldViewKeybordType.cardNumber.rawValue, InputTextFieldViewKeybordType.cvv.rawValue:
            type = .numberPad
        default:
            type = .default
        }
        textField?.keyboardType = type
    }
    
    private func setupKeyboardCapitalization(with type: Int) {
        switch type {
        case InputTextFieldViewKeybordType.name.rawValue:
            textField?.autocapitalizationType = .words
        case InputTextFieldViewKeybordType.email.rawValue:
            textField?.autocapitalizationType = .none
        default:
            textField?.autocapitalizationType = .sentences
        }
    }
    
    private func setupKeyboardSecureTextEntry(with type: Int) {
        let secureTextEntry = type == InputTextFieldViewKeybordType.password.rawValue || type == InputTextFieldViewKeybordType.cvv.rawValue
        textField?.isSecureTextEntry = secureTextEntry
        showPasswordButton?.isHidden = type != InputTextFieldViewKeybordType.password.rawValue || hideShowPasswordButton == true
    }
    
    // MARK: - Actions
    
    @IBAction func editingDidBegin(_ sender: UITextField) {
        state = .highlighted
        if placeholderVerticallyConstraint.constant == 0 {
            updatePlaceholderPosition(toTop: true, animated: true)
        }
    }
    
    @IBAction func editingDidEnd(_ sender: UITextField) {
        state = .normal
        guard let text = textField.text else {
            return
        }
        delegate?.textFieldView?(self, didEndUpdate: text)
        if text.isEmpty {
            updatePlaceholderPosition(toTop: false, animated: true)
        }
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        if state != .highlighted {
            state = .highlighted
        }
        if keyboardType == InputTextFieldViewKeybordType.cardNumber.rawValue {
            textField.text = textField.text?.asCardMaskNumber()
        }
        guard let text = textField.text else {
            return
        }
        delegate?.textFieldView?(self, didUpdate: text)
    }
    
    @IBAction func showPasswordTapped(_ sender: UIButton) {
        showPasswordButton.isSelected = !showPasswordButton.isSelected
        textField?.isSecureTextEntry = !showPasswordButton.isSelected
    }

    // MARK: - UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let generatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else {
            return true
        }
        
        switch keyboardType {
        case InputTextFieldViewKeybordType.cardNumber.rawValue:
            return generatedString.asCardDefaultNumber().count <= CreditCardLimit.cardNumberMaxCount
        case InputTextFieldViewKeybordType.cvv.rawValue:
            return generatedString.count <= CreditCardLimit.cvvMaxCount
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}
