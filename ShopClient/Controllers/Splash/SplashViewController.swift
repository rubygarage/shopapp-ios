//
//  SplashViewController2.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/30/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SplashViewController: UIViewController {
    var splashViewModel = SplashViewModel()
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadRemoteData()
    }
    
    private func loadRemoteData() {
        splashViewModel.data.subscribe(onSuccess: { [weak self] (shop, categories) in
            self?.setHomeController()
        }) { [weak self] (error) in
            self?.showErrorAlert(with: error.localizedDescription, handler: { [weak self] (action) in
                self?.setHomeController()
            })
        }.disposed(by: disposeBag)
    }
}
