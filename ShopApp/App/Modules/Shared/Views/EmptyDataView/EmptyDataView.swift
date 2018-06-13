//
//  EmptyDataView.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 6/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol EmptyDataViewDelegate: class {
    func emptyDataViewDidTapButton(_ view: EmptyDataView)
}

class EmptyDataView: UIView {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var button: UIButton!
    
    weak var delegate: EmptyDataViewDelegate?
    
    // MARK: - View lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    // MARK: - Setup
    
    func setup(image: UIImage, text: String, buttonTitle: String? = nil) {
        imageView.image = image
        label.text = text
        button.isHidden = buttonTitle == nil
        
        if let buttonTitle = buttonTitle {
            button.setTitle(buttonTitle, for: .normal)
        }
    }
    
    private func commonInit() {
        loadFromNib()
    }
    
    // MARK: - Actions
    
    @IBAction func buttonDidPress(_ sender: UIButton) {
        delegate?.emptyDataViewDidTapButton(self)
    }
}
