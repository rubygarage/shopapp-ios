//
//  LoadingView.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/2/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    // MARK: - View lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    // MARK: - Setup
    
    private func commonInit() {
        loadFromNib()
    }
}
