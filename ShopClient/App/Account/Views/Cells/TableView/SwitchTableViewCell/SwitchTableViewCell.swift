//
//  SwitchTableViewCell.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift

protocol SwitchTableViewCellProtocol: class {
    func stateDidChange(at indexPath: IndexPath, value: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    @IBOutlet private weak var swicthDescriptionlabel: UILabel!
    @IBOutlet private weak var switchControl: UISwitch!
    
    private let disposeBag = DisposeBag()
    
    private var indexPath: IndexPath!
    
    weak var delegate: SwitchTableViewCellProtocol?
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        let switchResults = switchControl.rx.isOn
            .debounce(0.3, scheduler: MainScheduler.instance)
            .observeOn(MainScheduler.instance)

        switchResults.asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] value in
                guard let `self` = self else {
                    return
                }
                
                self.delegate?.stateDidChange(at: self.indexPath, value: value)
            })
            .disposed(by: disposeBag)
    }
    
    func configure(with indexPath: IndexPath, description: String, state: Bool = false) {
        self.indexPath = indexPath
        swicthDescriptionlabel.text = description
        switchControl.isOn = state
    }
    
    // MARK: - Actions
    
    @IBAction func switchControlValueDidChange(_ sender: UISwitch) {
        //delegate?.stateDidChange(at: indexPath, value: sender.isOn)
    }
}
