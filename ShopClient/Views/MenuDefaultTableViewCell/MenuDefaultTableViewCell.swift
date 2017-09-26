//
//  MenuDefaultTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class MenuDefaultTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func configure(with title: String?) {
        titleLabel.text = title
    }
}
