//
//  AddressListTableHeaderView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol AddressListHeaderViewDelegate: class {
    func tableViewHeaderDidTapAddAddress(_ header: AddressListTableHeaderView)
}

class AddressListTableHeaderView: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var addNewAddressButton: BlackButton!
    
    weak var delegate: AddressListHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: AddressListTableHeaderView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupViews()
    }
    
    private func setupViews() {
        addNewAddressButton.setTitle("Button.AddNewAddress".localizable.uppercased(), for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func addNewAddressTapped(_ sender: BlackButton) {
        delegate?.tableViewHeaderDidTapAddAddress(self)
    }
}
