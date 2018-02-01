//
//  CartButtonView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import RxSwift

private let kItemsCountViewCornerRadius: CGFloat = 7

class CartButtonView: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var itemsCountLabel: UILabel!
    @IBOutlet private weak var itemsCountBackgroundView: UIView!
    
    private let disposeBag = DisposeBag()
    private var viewModel = CartButtonViewModel()
    
    // MARK: - View lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
        setupViews()
    }
    
    // MARK: - Setup
    
    private func commonInit() {
        let viewName = String(describing: CartButtonView.self)
        Bundle.main.loadNibNamed(viewName, owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        populateViews()
        
        viewModel.cartItemsCount.asObservable()
            .subscribe(onNext: { [weak self] cartItemsCount in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.populateViews(with: cartItemsCount)
            })
            .disposed(by: disposeBag)
        
        viewModel.getCartItemsCount()
    }
    
    private func setupViews() {
        itemsCountBackgroundView.layer.cornerRadius = kItemsCountViewCornerRadius
    }
    
    private func populateViews(with itemsCount: Int = 0) {
        itemsCountLabel.text = "\(itemsCount)"
        itemsCountLabel.isHidden = itemsCount == 0
        itemsCountBackgroundView.isHidden = itemsCount == 0
    }
}
