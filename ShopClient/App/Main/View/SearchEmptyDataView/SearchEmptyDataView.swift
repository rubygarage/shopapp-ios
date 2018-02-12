//
//  SearchEmptyDataView.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 2/5/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class SearchEmptyDataView: UIView {
    @IBOutlet private weak var emptySearchLabel: UILabel!
    
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
        setupViews()
    }
    
    private func setupViews() {
        emptySearchLabel.text = "Label.NoResultFound".localizable
    }
}
