//
//  BlackButton.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 12/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class BlackButton: UIButton {
    private let buttonColorNormal = UIColor.black
    private let buttonColorHighlited = UIColor.black.withAlphaComponent(0.8)
    private let buttonColorDisabled = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? buttonColorHighlited : buttonColorNormal
        }
    }
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? buttonColorNormal : buttonColorDisabled
            let titleColor = isEnabled ? UIColor.white : UIColor.gray
            setTitleColor(titleColor, for: .normal)
        }
    }
    
    // MARK: - View lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        backgroundColor = buttonColorNormal
    }
}
