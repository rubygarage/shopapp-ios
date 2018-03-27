//
//  SortVariantTableViewCell.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 2/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class SortVariantTableViewCell: UITableViewCell {
    @IBOutlet private weak var variantTitleLabel: UILabel!
    @IBOutlet private weak var checkImageView: UIImageView!

    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    // MARK: - Setup
    
    func configure(with variant: String, selected: Bool) {
        variantTitleLabel.text = variant
        checkImageView.isHidden = !selected
    }
    
}
