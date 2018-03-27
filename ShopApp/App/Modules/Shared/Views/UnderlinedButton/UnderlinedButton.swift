//
//  UnderlinedButton.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 12/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol UnderlinedButtonDelegate: class {
    func underlinedButton(_ button: UnderlinedButton, didChangeState isHighlighted: Bool)
}

class UnderlinedButton: UIButton {
    weak var delegate: UnderlinedButtonDelegate?
    
    override var isHighlighted: Bool {
        didSet {
            delegate?.underlinedButton(self, didChangeState: isHighlighted)
        }
    }
    override var isEnabled: Bool {
        didSet {
            let titleColor = isEnabled ? UIColor.black : UIColor.gray
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
        setTitleColor(.black, for: .normal)
    }
}
