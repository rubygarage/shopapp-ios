//
//  SortModalTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class SortModalTableViewCell: UITableViewCell {
    @IBOutlet private weak var sortItemTitleLabel: UILabel!
    @IBOutlet private weak var selectedIndicatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        selectedIndicatorView.isHidden = true
        selectedIndicatorView.layer.cornerRadius = selectedIndicatorView.frame.size.width / 2
    }
    
    func configure(with title: String?, selected: Bool) {
        sortItemTitleLabel.text = title
        selectedIndicatorView.isHidden = !selected
    }
}
