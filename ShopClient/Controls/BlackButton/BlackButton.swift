//
//  BlackButton.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

private let kButtonColorNormal = UIColor.black
private let kButtonColorHighlited = UIColor.black.withAlphaComponent(0.8)
private let kButtonColorDisabled = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)

class BlackButton: UIButton {
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? kButtonColorHighlited : kButtonColorNormal
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? kButtonColorNormal : kButtonColorDisabled
            let titleColor = isEnabled ? UIColor.white : UIColor.gray
            setTitleColor(titleColor, for: .normal)
        }
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        backgroundColor = kButtonColorNormal
    }
}
