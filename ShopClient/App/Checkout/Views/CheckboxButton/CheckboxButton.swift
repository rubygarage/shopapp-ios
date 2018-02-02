//
//  CheckboxButton.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/26/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

private let kBodredWidth: CGFloat = 1
private let kBorderColorSelected = UIColor(displayP3Red: 0.59, green: 0.59, blue: 0.59, alpha: 1).cgColor
private let kBorderColorDefault = kBorderColorSelected.copy(alpha: 0.5)

class CheckboxButton: UIButton {
    override open var isHighlighted: Bool {
        didSet {
            updateUI()
        }
    }
    override var isSelected: Bool {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        layer.borderWidth = kBodredWidth
        layer.borderColor = UIColor.red.cgColor
    }
    
    private func updateUI() {
        if isHighlighted {
            layer.borderColor = kBorderColorSelected
        } else {
            layer.borderColor = isSelected ? kBorderColorSelected : kBorderColorDefault
        }
    }
}
