//
//  CartTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/9/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import SDWebImage

protocol CartTableCellProtocol {
    func didTapRemove(with item: CartProduct)
}

class CartTableViewCell: UITableViewCell {
    @IBOutlet weak var backgroundShadowView: UIView!
    @IBOutlet weak var variantImageView: UIImageView!
    @IBOutlet weak var variantTitleLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var pricePerOneItemLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    var cartProduct: CartProduct?
    var delegate: CartTableCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        selectionStyle = .none
        
        backgroundShadowView.addShadow()
        quantityLabel.text = NSLocalizedString("Label.Quantity", comment: String())
        removeButton.setTitle(NSLocalizedString("Button.Remove", comment: String()), for: .normal)
    }
    
    public func configure(with item: CartProduct?, delegate: CartTableCellProtocol?) {
        cartProduct = item
        self.delegate = delegate
        populateImageView(with: item)
        populateTitle(with: item)
        populateQuantity(with: item)
        popualateTotalPrice(with: item)
        populatePricePerOne(with: item)
    }
    
    private func populateImageView(with item: CartProduct?) {
        let urlString = item?.productVariant?.image?.src ?? String()
        let url = URL(string: urlString)
        variantImageView.sd_setImage(with: url, completed: nil)
    }
    
    private func populateTitle(with item: CartProduct?) {
        let productTitle = item?.productTitle ?? String()
        let variantTitle = item?.productVariant?.title ?? String()
        variantTitleLabel.text = "\(productTitle) \(variantTitle)"
    }
    
    private func populateQuantity(with item: CartProduct?) {
        let quantity = item?.quantity ?? 0
        quantityTextField.text = "\(quantity)"
    }
    
    private func popualateTotalPrice(with item: CartProduct?) {
        let quantity = Float(item?.quantity ?? 0)
        let priceString = item?.productVariant?.price ?? String()
        let price = (priceString as NSString).floatValue
        let currency = item?.currency ?? String()
        totalPriceLabel.text = "\(quantity * price) \(currency)"
    }
    
    func populatePricePerOne(with item: CartProduct?) {
        let quantity = item?.quantity ?? 1
        if quantity > 1 {
            let price = item?.productVariant?.price ?? String()
            let currency = item?.currency ?? String()
            let localizedString = NSLocalizedString("Label.PriceEach", comment: String())
            pricePerOneItemLabel.text = String.localizedStringWithFormat(localizedString, price, currency)
        } else {
            pricePerOneItemLabel.text = nil
        }
    }
    
    // MARK: - actions
    @IBAction func removeTapped(_ sender: UIButton) {
        if let cartProduct = cartProduct {
            delegate?.didTapRemove(with: cartProduct)
        }
    }
}
