//
//  CriticalErrorView.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 4/26/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

enum ErrorItemType: String {
    case `default`
    case product
    case article
    case category
    case order
}

protocol CriticalErrorViewDelegate: class {
    func criticalErrorViewDidTapBack(_ view: CriticalErrorView)
}

class CriticalErrorView: UIView {
    @IBOutlet private weak var errorTitleLabel: UILabel!
    @IBOutlet private weak var backButton: GrayButton!
    
    var itemType: ErrorItemType? {
        didSet {
            updateTitle()
        }
    }
    
    weak var delegate: CriticalErrorViewDelegate?
    
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
    
    private func commonInit() {
        loadFromNib()
        
        updateTitle()
        backButton.setTitle("Button.Back".localizable.uppercased(), for: .normal)
    }
    
    private func updateTitle() {
        guard let type = itemType else {
            errorTitleLabel.text = "Label.CouldNotFind".localizable
            
            return
        }
        
        errorTitleLabel.text = String.localizedStringWithFormat("Label.CouldNotFindItem".localizable, type.rawValue)
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonDidPress(_ sender: UIButton) {
        delegate?.criticalErrorViewDidTapBack(self)
    }
}
