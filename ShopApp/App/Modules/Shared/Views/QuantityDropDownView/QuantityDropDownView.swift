//
//  QuantityDropDownView.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 4/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit
import DropDown

let kCartProductQuantityMax = 999

enum DropDownItem: Int {
    case one
    case two
    case three
    case four
    case five
    case more
    
    static let allValues = ["1", "2", "3", "4", "5", "Label.PlusMore".localizable.uppercased()]
}

@objc protocol QuantityDropDownViewDelegate: class {
    @objc optional func quantityDropDownView(_ view: QuantityDropDownView, didChange quantity: Int)
    func quantityDropDownView(_ view: QuantityDropDownView, didSelectMoreWith quantity: Int)
}

class QuantityDropDownView: TextFieldWrapper, UITextFieldDelegate {
    private let maxDropdownQuantity = 5
    private let cartProductQuantityMin = 1
    private let dropDown = DropDown()
    
    weak var delegate: QuantityDropDownViewDelegate?
    
    private var quantity: Int {
        guard let stringValue = text, let value = Int(stringValue) else {
            return cartProductQuantityMin
        }
        return value
    }
    
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(quantityTapRecognizerDidPress(_:)))
        addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
    
    @objc private func quantityTapRecognizerDidPress(_ sender: UITapGestureRecognizer) {
        if quantity > maxDropdownQuantity {
            delegate?.quantityDropDownView(self, didSelectMoreWith: quantity)
        } else {
            showDropDown()
        }
    }
    
    @IBAction func quantityEditingDidEnd(_ sender: UITextField) {
        var quantity = (sender.text as NSString?)?.integerValue ?? 0
        if quantity < cartProductQuantityMin {
            quantity = cartProductQuantityMin
            textField.text = String(quantity)
        }
        delegate?.quantityDropDownView?(self, didChange: quantity)
    }
    
    private func showDropDown() {
        dropDown.dataSource = DropDownItem.allValues
        dropDown.anchorView = self
        dropDown.backgroundColor = .white
        dropDown.selectionBackgroundColor = Colors.backgroundDefault
        dropDown.cellNib = UINib(nibName: QuantityDropDownTableViewCell.nameOfClass, bundle: nil)
        
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) in
            guard let cell = cell as? QuantityDropDownTableViewCell else {
                return
            }
            
            let textCenter = index == DropDownItem.more.rawValue
            cell.configure(with: textCenter)
        }
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let strongSelf = self else {
                return
            }
            
            if index == DropDownItem.more.rawValue {
                strongSelf.delegate?.quantityDropDownView(strongSelf, didSelectMoreWith: strongSelf.quantity)
            } else {
                strongSelf.textField.text = item
                strongSelf.textField.sendActions(for: .editingDidEnd)
                strongSelf.delegate?.quantityDropDownView?(strongSelf, didChange: strongSelf.quantity)
            }
        }
        
        dropDown.show()
    }
}
