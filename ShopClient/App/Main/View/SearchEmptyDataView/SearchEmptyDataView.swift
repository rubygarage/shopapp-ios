//
//  SearchEmptyDataView.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 2/5/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class SearchEmptyDataView: UIView {
    @IBOutlet private weak var contentView: UIView!
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
        let viewName = String(describing: SearchEmptyDataView.self)
        Bundle.main.loadNibNamed(viewName, owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupViews()
    }
    
    private func setupViews() {
        emptySearchLabel.text = "Label.NoResultFound".localizable
    }
}
