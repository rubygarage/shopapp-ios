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
        quantityLabel.text = "Label.Order.Quantity".localizable
    }
    
    func configure(with orderItem: OrderItem, currencyCode: String) {
        let formatter = NumberFormatter.formatter(with: currencyCode)
        let price = NSDecimalNumber(string: orderItem.productVariant!.price!)
        let totalPrice = NSDecimalNumber(value: price.doubleValue * Double(orderItem.quantity!))
        
        totalPriceLabel.text = formatter.string(from: totalPrice)
        titleLabel.text = orderItem.title
        quantityValueLabel.text = String(orderItem.quantity!)
        itemPriceLabel.isHidden = !(orderItem.quantity! > 1)
        
        if orderItem.quantity! > 1 {
            let eachText = "Label.Order.Each".localizable
            itemPriceLabel.text = String(format: "%@ %@", formatter.string(from: price)!, eachText)
        }
        
        if let options = orderItem.productVariant!.selectedOptions {
            var subtitle = ""
            
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
