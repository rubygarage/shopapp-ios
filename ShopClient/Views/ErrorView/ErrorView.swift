//
//  ErrorView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/2/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

@objc protocol ErrorViewProtocol {
    @objc optional func didTapTryAgain()
}

class ErrorView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var errorTextLabel: UILabel!
    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    var delegate: ErrorViewProtocol?
    var error: RepoError? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: ErrorView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func updateUI() {
        errorImageView.isHidden = error is NetworkError == false
        errorTextLabel.text = error?.errorMessage
    }
    
    // MARK: - actions
    @IBAction func tryAgainTapped(_ sender: UIButton) {
        delegate?.didTapTryAgain?()
    }
}
