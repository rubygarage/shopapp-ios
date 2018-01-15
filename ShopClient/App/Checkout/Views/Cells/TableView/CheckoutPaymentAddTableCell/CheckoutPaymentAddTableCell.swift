//
//  CheckoutPaymentAddTableCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CheckoutPaymentAddCellProtocol: class {
    func didTapAddPayment()
}

class CheckoutPaymentAddTableCell: UITableViewCell {
    
    @IBOutlet weak var addPaymentButton: BlackButton!
    
    weak var delegate: CheckoutPaymentAddCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        addPaymentButton.setTitle("Button.AddPaymentType".localizable.uppercased(), for: .normal)
    }
    
    // MARK: - actions
    
    @IBAction func addPaymentTapped(_ sender: BlackButton) {
        delegate?.didTapAddPayment()
    }
}
