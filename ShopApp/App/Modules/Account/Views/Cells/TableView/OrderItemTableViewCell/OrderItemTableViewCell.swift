//
//  OrderItemTableViewCell.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/5/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

class OrderItemTableViewCell: UITableViewCell {
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var quantityValueLabel: UILabel!
    
    @IBOutlet private weak var itemPriceLabel: UILabel! {
        didSet {
            itemPriceLabel.isHidden = true
        }
    }
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        setupViews()
    }
    
    // MARK: - Setup
    
    func configure(with orderProduct: OrderProduct, currencyCode: String) {
        itemImageView.set(image: orderProduct.productVariant?.image)
        
        titleLabel.text = orderProduct.title
        quantityValueLabel.text = String(orderProduct.quantity)
        
        guard let productVariant = orderProduct.productVariant else {
            totalPriceLabel.text = "Label.N/A".localizable
            subtitleLabel.text = nil
            itemPriceLabel.isHidden = true
            return
        }
        
        let formatter = NumberFormatter.formatter(with: currencyCode)
        let price = NSDecimalNumber(decimal: productVariant.price)
        let totalPrice = NSDecimalNumber(value: price.doubleValue * Double(orderProduct.quantity))
        
        totalPriceLabel.text = formatter.string(from: totalPrice)
        itemPriceLabel.isHidden = !(orderProduct.quantity > 1)
        
        if orderProduct.quantity > 1 {
            itemPriceLabel.text = String.localizedStringWithFormat("Label.PriceEach".localizable, formatter.string(from: price)!)
        }
        
        guard !productVariant.selectedOptions.isEmpty else {
            subtitleLabel.text = nil
            return
        }
        
        var subtitle = ""
        
        for index in 0..<productVariant.selectedOptions.count {
            let selectedOption = productVariant.selectedOptions[index]
            let text = String.localizedStringWithFormat("Label.Order.Option".localizable, selectedOption.name, selectedOption.value)
            subtitle.append(text)

            if index < productVariant.selectedOptions.count - 1 {
                subtitle.append("\n")
            }
        }
        
        subtitleLabel.text = subtitle
    }
    
    private func setupViews() {
        quantityLabel.text = "Label.Order.Quantity".localizable
    }
}
