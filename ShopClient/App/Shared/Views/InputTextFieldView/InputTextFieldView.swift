//
//  InputTextFieldView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

enum InputTextFieldViewState {
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

private let kUnderlineViewAlphaDefault: CGFloat = 0.2
private let kUnderlineViewAlphaHighlighted: CGFloat = 1
private let kUnderlineViewHeightDefault: CGFloat = 1
private let kUnderlineViewHeightHighlighted: CGFloat = 2
private let kErrorColor = UIColor(displayP3Red: 0.89, green: 0.31, blue: 0.31, alpha: 1)

class InputTextFieldView: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var underlineView: UIView!
    @IBOutlet private weak var underlineViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var errorMesageLabel: UILabel!
    @IBOutlet private weak var showPasswordButton: UIButton!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBInspectable var keyboardType: Int = InputTextFieldViewKeybordType.name.rawValue {
        didSet {
            setupKeyboardType(with: keyboardType)
            setupKeyboardSecureTextEntry(with: keyboardType)
            setupKeyboardCapitalization(with: keyboardType)
            setupKeyboardCorrection(with: keyboardType)
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
            errorMesageLabel.text = errorMessage
            updateUI()
        }
    }
    var placeholder: String? {
        didSet {
            textField?.attributedPlaceholder = NSAttributedString(string: placeholder ?? String(), attributes: [NSForegroundColorAttributeName: UIColor.black])
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
        Bundle.main.loadNibNamed(String(describing: InputTextFieldView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        textField?.delegate = self
        setupViews()
        updateUI()
    }
    
    private func setupViews() {
        backgroundColor = UIColor.clear
        errorMesageLabel.textColor = kErrorColor
    }
    
    private func updateUI() {
        underlineView.alpha = state == .normal ? kUnderlineViewAlphaDefault : kUnderlineViewAlphaHighlighted
        underlineViewHeightConstraint.constant = state == .normal ? kUnderlineViewHeightDefault : kUnderlineViewHeightHighlighted
        underlineView.backgroundColor = state == .error ? kErrorColor : UIColor.black
        errorMesageLabel.isHidden = state != .error
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
    
    private func setupKeyboardCorrection(with type: Int) {
        textField?.autocorrectionType = type == InputTextFieldViewKeybordType.email.rawValue ? .no : .yes
    }
    
    private func setupKeyboardSecureTextEntry(with type: Int) {
        let secureTextEntry = type == InputTextFieldViewKeybordType.password.rawValue || type == InputTextFieldViewKeybordType.cvv.rawValue
        textField?.isSecureTextEntry = secureTextEntry
        showPasswordButton?.isHidden = type != InputTextFieldViewKeybordType.password.rawValue
    }
    
    // MARK: - Actions
    
    @IBAction func editingDidBegin(_ sender: UITextField) {
        state = .highlighted
    }
    
    @IBAction func editingDidEnd(_ sender: UITextField) {
        state = .normal
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        if state != .highlighted {
            state = .highlighted
        }
    }
    
    @IBAction func showPasswordTapped(_ sender: UIButton) {
        showPasswordButton.isSelected = !showPasswordButton.isSelected
        textField?.isSecureTextEntry = !showPasswordButton.isSelected
    }
}

// MARK: - UITextFieldDelegate

extension InputTextFieldView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let generatedString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        switch keyboardType {
        case InputTextFieldViewKeybordType.cardNumber.rawValue:
            return generatedString.count <= CreditCardLimit.cardNumberMaxCount
        case InputTextFieldViewKeybordType.cvv.rawValue:
            return generatedString.count <= CreditCardLimit.cvvMaxCount
        default:
            return true
        }
    }
}
