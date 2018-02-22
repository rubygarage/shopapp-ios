//
//  ErrorViewDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class ErrorViewDelegateMock: ErrorViewDelegate {
    var view: ErrorView?
    
    // MARK: - ErrorViewDelegate
    
    func viewDidTapTryAgain(_ view: ErrorView) {
        self.view = view
    }
}
