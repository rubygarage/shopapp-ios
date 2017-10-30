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

class SplashViewController2: UIViewController {
    var splashViewModel = SplashViewModel()
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRx()
    }
    
    private func setupRx() {
        splashViewModel.success.asObservable()
            .subscribe(onNext: { success in
                print("ffff")
            })
            .disposed(by: disposeBag)
    }
}
