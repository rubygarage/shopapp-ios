//
//  QuantityTextFieldView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

let kCartProductQuantityMax = 999

protocol QuantityTextFieldViewDelegate: class {
    func quantityTextFieldView(_ view: QuantityTextFieldView, didEndEditingWith quantity: Int)
}

class QuantityTextFieldView: TextFieldWrapper, UITextFieldDelegate {
    @IBOutlet private weak var underlineView: UIView!
    
    private let cartProductQuantityMin = 1
    private let quantityUnderlineColorDefault = UIColor(displayP3Red: 0.92, green: 0.92, blue: 0.92, alpha: 1)

    weak var delegate: QuantityTextFieldViewDelegate?

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
    }

    // MARK: - Actions

    @IBAction func quantityEditingDidBegin(_ sender: UITextField) {
        underlineView.backgroundColor = .black
    }

    @IBAction func quantityEditingDidEnd(_ sender: UITextField) {
        underlineView.backgroundColor = quantityUnderlineColorDefault

        var quantity = (sender.text as NSString?)?.integerValue ?? 0
        if quantity < cartProductQuantityMin {
            quantity = cartProductQuantityMin
            textField.text = String(quantity)
        }
        delegate?.quantityTextFieldView(self, didEndEditingWith: quantity)
    }
    
    // MARK: - UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let formattedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        let formattedQuantity = (formattedText as NSString?)?.integerValue ?? 0
        return formattedQuantity <= kCartProductQuantityMax
    }
}
