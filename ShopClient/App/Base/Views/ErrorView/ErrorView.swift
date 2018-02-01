//
//  ErrorView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/2/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol ErrorViewDelegate: class {
    func viewDidTapTryAgain(_ view: ErrorView)
}

class ErrorView: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var errorTextLabel: UILabel!
    @IBOutlet private weak var errorImageView: UIImageView!
    @IBOutlet private weak var tryAgainButton: UIButton!
    
    weak var delegate: ErrorViewDelegate?
    
    var error: RepoError? {
        didSet {
            updateUI()
        }
    }
    
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
        let viewName = String(describing: ErrorView.self)
        Bundle.main.loadNibNamed(viewName, owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func updateUI() {
        errorImageView.isHidden = error is NetworkError == false
        errorTextLabel.text = error?.errorMessage
    }
    
    // MARK: - Actions
    
    @IBAction private func tryAgainButtonDidTap(_ sender: UIButton) {
        delegate?.viewDidTapTryAgain(self)
    }
}
