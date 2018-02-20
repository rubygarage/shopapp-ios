//
//  QuantityTextFieldView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

private let kCartProductQuantityMin = 1
private let kQuantityUnderlineColorDefault = UIColor(displayP3Red: 0.92, green: 0.92, blue: 0.92, alpha: 1)

let kCartProductQuantityMax = 999

protocol QuantityTextFieldViewDelegate: class {
    func quantityTextFieldView(_ view: QuantityTextFieldView, didEndEditingWith quantity: Int)
}

class QuantityTextFieldView: TextFieldWrapper {
    @IBOutlet private weak var underlineView: UIView!

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

    private func check(quantity: Int) -> Int {
        guard quantity < kCartProductQuantityMin else {
            return quantity
        }
        return kCartProductQuantityMin
    }

    // MARK: - Actions

    @IBAction func quantityEditingDidBegin(_ sender: UITextField) {
        underlineView.backgroundColor = .black
    }

    @IBAction func quantityEditingDidEnd(_ sender: UITextField) {
        underlineView.backgroundColor = kQuantityUnderlineColorDefault

        var quantity = (sender.text as NSString?)?.integerValue ?? 0
        if quantity < kCartProductQuantityMin {
            quantity = kCartProductQuantityMin
            textField.text = String(quantity)
        }
        delegate?.quantityTextFieldView(self, didEndEditingWith: quantity)
    }
}

extension QuantityTextFieldView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let formattedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        let formattedQuantity = (formattedText as NSString?)?.integerValue ?? 0
        return formattedQuantity <= kCartProductQuantityMax
    }
}
