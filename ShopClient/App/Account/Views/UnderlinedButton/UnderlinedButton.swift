//
//  UnderlinedButton.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol UnderlinedButtonProtocol: class {
    func didChangeState(isHighlighted: Bool)
}

class UnderlinedButton: UIButton {
    
    weak var delegate: UnderlinedButtonProtocol?
    
    override open var isHighlighted: Bool {
        didSet {
            delegate?.didChangeState(isHighlighted: isHighlighted)
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            let titleColor = isEnabled ? UIColor.black : UIColor.gray
            setTitleColor(titleColor, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        setTitleColor(UIColor.black, for: .normal)
    }
}
