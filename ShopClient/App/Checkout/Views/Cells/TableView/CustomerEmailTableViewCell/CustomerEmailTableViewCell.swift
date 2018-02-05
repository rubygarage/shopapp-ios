//
//  CustomerEmailTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class CustomerEmailTableViewCell: UITableViewCell {
    @IBOutlet private weak var emailTextFieldView: InputTextFieldView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        setupViews()
    }
    
    private func setupViews() {
        emailTextFieldView.placeholder = "Placeholder.Email".localizable.required.uppercased()
    }
}
