//
//  SplashViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/30/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

struct SplashViewModel {
    var success = Variable<Bool>(false)
    
    var loadData: AnyObserver<Void> {
        return AnyObserver { event in
            self.loadRemoteData()
        }
    }
    
    // MARK: - private
    private func loadRemoteData() {
        
    }
}
