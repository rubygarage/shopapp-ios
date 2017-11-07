//
//  CartButtonView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

let kItemsCountViewCornerRadius: CGFloat = 5

class CartButtonView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var itemsCountLabel: UILabel!
    @IBOutlet weak var itemsCountBackgroundView: UIView!
    
    var itemsCount: Int = 0 {
        didSet {
            populateViews()
        }
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
        setupViews()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: CartButtonView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setupViews() {
        itemsCountBackgroundView.layer.cornerRadius = kItemsCountViewCornerRadius
    }
    
    private func populateViews() {
        itemsCountLabel.text = "\(itemsCount)"
    }
}
