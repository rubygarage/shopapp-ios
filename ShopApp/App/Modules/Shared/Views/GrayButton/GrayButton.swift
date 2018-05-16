//
//  GrayButton.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 4/27/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class GrayButton: UIButton {
    private let cornerRadius: CGFloat = 3
    
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
        layer.cornerRadius = cornerRadius
    }
}
