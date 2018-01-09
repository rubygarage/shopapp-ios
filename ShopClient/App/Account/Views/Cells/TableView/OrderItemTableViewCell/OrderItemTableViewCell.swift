//
//  OrderItemTableViewCell.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/5/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class OrderItemTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityValueLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel! {
        didSet {
            itemPriceLabel.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        setupViews()
    }
    
    private func setupViews() {
        quantityLabel.text = NSLocalizedString("Label.Order.Quantity", comment: String())
    }
    
    func configure(with orderItem: OrderItem, currencyCode: String) {
        let price = Double(orderItem.productVariant!.price!)!
        let totalPrice = price * Double(orderItem.quantity!)
        
        totalPriceLabel.text = String(format: "%.2f %@", totalPrice, currencyCode)
        titleLabel.text = orderItem.title
        quantityValueLabel.text = String(orderItem.quantity!)
        itemPriceLabel.isHidden = !(orderItem.quantity! > 1)
        
        if orderItem.quantity! > 1 {
            let eachText = NSLocalizedString("Label.Order.Each", comment: String())
            itemPriceLabel.text = String(format: "%.2f %@ %@", price, currencyCode, eachText)
        }
        
        if let options = orderItem.productVariant!.selectedOptions {
            var subtitle = String()
            
            options.forEach {
                let text = String(format: "%@: %@", $0.name, $0.value)
                subtitle.append(text)
                
                if options.last != $0 {
                    subtitle.append("\n")
                }
            }
            
            subtitleLabel.text = subtitle
        } else {
            subtitleLabel.text = nil
        }
    }
}
