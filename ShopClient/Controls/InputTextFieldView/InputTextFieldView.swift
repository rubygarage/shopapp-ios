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

private let kUnderlineViewAlphaDefault: CGFloat = 0.2
private let kUnderlineViewAlphaHighlighted: CGFloat = 1
private let kUnderlineViewHeightDefault: CGFloat = 1
private let kUnderlineViewHeightHighlighted: CGFloat = 2
private let kErrorColor = UIColor(displayP3Red: 0.89, green: 0.31, blue: 0.31, alpha: 1)

class InputTextFieldView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var underlineViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorMesageLabel: UILabel!
    @IBOutlet weak var showPasswordButton: UIButton!
    
    private var isTextSecure: Bool = false
    
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
    
    @IBInspectable
    var isSecure: Bool = false {
        didSet {
            textField?.isSecureTextEntry = isSecure
            showPasswordButton?.isHidden = !isSecure
        }
    }
    
    // MARK: - initialization
    init() {
        super.init(frame: CGRect.zero)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: InputTextFieldView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupViews()
        updateUI()
    }
    
    private func setupViews() {
        backgroundColor = UIColor.clear
        errorMesageLabel.textColor = kErrorColor
        textField.isSecureTextEntry = isSecure
    }
    
    private func updateUI() {
        underlineView.alpha = state == .normal ? kUnderlineViewAlphaDefault : kUnderlineViewAlphaHighlighted
        underlineViewHeightConstraint.constant = state == .normal ? kUnderlineViewHeightDefault : kUnderlineViewHeightHighlighted
        underlineView.backgroundColor = state == .error ? kErrorColor : UIColor.black
        errorMesageLabel.isHidden = state != .error
    }
    
    // MARK: - actions
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
