//
//  AddressListTableHeaderView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol AddressListHeaderViewProtocol {
    func didTapAddNewAddress()
}

class AddressListTableHeaderView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var addNewAddressButton: BlackButton!
    
    private var delegate: AddressListHeaderViewProtocol!
    
    init(delegate: AddressListHeaderViewProtocol) {
        super.init(frame: CGRect.zero)
        
        self.delegate = delegate
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
    
    // MARK: - actions
    @IBAction func addNewAddressTapped(_ sender: BlackButton) {
        delegate.didTapAddNewAddress()
    }
}
