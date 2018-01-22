//
//  SwitchTableViewCell.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellProtocol: class {
    func stateDidChange(at indexPath: IndexPath, value: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    @IBOutlet private weak var swicthDescriptionlabel: UILabel!
    @IBOutlet private weak var switchControl: UISwitch!
    
    private var indexPath: IndexPath!
    
    weak var delegate: SwitchTableViewCellProtocol?
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    // MARK: - Setup
    
    func configure(with indexPath: IndexPath, description: String, state: Bool = false) {
        self.indexPath = indexPath
        swicthDescriptionlabel.text = description
        switchControl.isOn = state
    }
    
    // MARK: - Actions
    
    @IBAction func switchControlValueDidChange(_ sender: UISwitch) {
        delegate?.stateDidChange(at: indexPath, value: sender.isOn)
    }
}
