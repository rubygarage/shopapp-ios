//
//  CartButtonView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import RxSwift
import Swinject

private let kItemsCountViewCornerRadius: CGFloat = 7

class CartButtonView: UIView {
    @IBOutlet private weak var itemsCountLabel: UILabel!
    @IBOutlet private weak var itemsCountBackgroundView: UIView!
    
    private let disposeBag = DisposeBag()
    private let viewModel = AppDelegate.getAssembler().resolver.resolve(CartButtonViewModel.self)!
    
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
        loadFromNib()
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
