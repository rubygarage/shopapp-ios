//
//  CriticalErrorViewDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

@testable import ShopApp

class CriticalErrorViewDelegateMock: CriticalErrorViewDelegate {
    var view: CriticalErrorView?
    
    // MARK: - CriticalErrorViewDelegate
    
    func criticalErrorViewDidTapBack(_ view: CriticalErrorView) {
        self.view = view
    }
}
