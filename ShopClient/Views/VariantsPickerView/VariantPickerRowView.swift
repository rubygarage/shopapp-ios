//
//  VariantPickerRowView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class VariantPickerRowView: UIView {
    @IBOutlet weak var variantImageView: UIImageView!
    @IBOutlet weak var variantTitleLabel: UILabel!
    @IBOutlet weak var variantPriceLabel: UILabel!
    
    init(frame: CGRect, variant: ProductVariant, currency: String?) {
        super.init(frame: frame)
        
        nibSetup()
        populate(with: variant, currency: currency)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        nibSetup()
    }
    
    private func nibSetup() {
        backgroundColor = UIColor.clear
        
        let view = instanceFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
    }
    
    private func instanceFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }

    private func populate(with variant: ProductVariant, currency: String?) {
        let url = URL(string: variant.image?.src ?? String())
        variantImageView.sd_setImage(with: url)
        variantTitleLabel.text = variant.title
        variantPriceLabel.text = "\(variant.price) \(currency ?? String())"
    }
}
