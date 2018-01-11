//
//  CheckoutPaymentAddTableCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CheckoutPaymentAddCellProtocol {
    func didTapAddPayment()
}

class CheckoutPaymentAddTableCell: UITableViewCell {
    @IBOutlet weak var addPaymentButton: BlackButton!
    
    var delegate: CheckoutPaymentAddCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        addPaymentButton.setTitle(NSLocalizedString("Button.AddPaymentType", comment: String()).uppercased(), for: .normal)
    }
    
    // MARK: - actions
    @IBAction func addPaymentTapped(_ sender: BlackButton) {
        delegate?.didTapAddPayment()
    }
}
