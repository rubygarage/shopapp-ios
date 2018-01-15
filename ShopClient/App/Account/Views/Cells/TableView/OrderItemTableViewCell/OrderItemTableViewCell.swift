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
        let image = orderItem.productVariant?.image ?? Image()
        let imageUrl = URL(string: image.src ?? "")
        itemImageView.sd_setImage(with: imageUrl)
        
        titleLabel.text = orderItem.title
        quantityValueLabel.text = String(orderItem.quantity!)
        
        if let productVariant = orderItem.productVariant {
            let formatter = NumberFormatter.formatter(with: currencyCode)
            let price = NSDecimalNumber(string: productVariant.price!)
            let totalPrice = NSDecimalNumber(value: price.doubleValue * Double(orderItem.quantity!))
        
            totalPriceLabel.text = formatter.string(from: totalPrice)
            itemPriceLabel.isHidden = !(orderItem.quantity! > 1)
            
            if orderItem.quantity! > 1 {
                itemPriceLabel.text = String.localizedStringWithFormat("Label.PriceEach".localizable, formatter.string(from: price)!)
            }
            
            if let options = productVariant.selectedOptions {
                var subtitle = ""
                
                options.forEach {
                    let text = String.localizedStringWithFormat("Label.Order.Option".localizable, $0.name, $0.value)
                    subtitle.append(text)
                    
                    if options.last != $0 {
                        subtitle.append("\n")
                    }
                }
                
                subtitleLabel.text = subtitle
            } else {
                subtitleLabel.text = nil
            }
        } else {
            totalPriceLabel.text = "Label.N/A".localizable
            subtitleLabel.text = nil
            itemPriceLabel.isHidden = true
        }
    }
}
