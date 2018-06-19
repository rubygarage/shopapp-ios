//
//  SplashViewController.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 4/24/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController<SplashViewModel> {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var loadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
        setupProvider()
    }
    
    private func setupViews() {
        titleLabel.text = "Label.ShopApp".localizable
        loadingLabel.text = "Label.Loading".localizable
    }
    
    private func setupViewModel() {
        viewModel.providerDidSetup
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.setTabBarController()
            })
        .disposed(by: disposeBag)
    }
    
    private func setupProvider() {
        viewModel.setupProvider()
    }
}
