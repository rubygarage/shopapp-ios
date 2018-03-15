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

class CartButtonView: UIView {
    @IBOutlet private weak var itemsCountLabel: UILabel!
    @IBOutlet private weak var itemsCountBackgroundView: UIView!
    
    private let itemsCountViewCornerRadius: CGFloat = 7
    private let disposeBag = DisposeBag()
    
    var viewModel: CartButtonViewModel! {
        didSet {
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
    }
    
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
        
        if let viewModel = AppDelegate.getAssembler().resolver.resolve(CartButtonViewModel.self) {
            self.viewModel = viewModel
        }
    }
    
    private func setupViews() {
        itemsCountBackgroundView.layer.cornerRadius = itemsCountViewCornerRadius
    }
    
    private func populateViews(with itemsCount: Int = 0) {
        itemsCountLabel.text = "\(itemsCount)"
        itemsCountLabel.isHidden = itemsCount == 0
        itemsCountBackgroundView.isHidden = itemsCount == 0
    }
}
