//
//  EmptyDataViewDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 6/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

@testable import ShopApp

class EmptyDataViewDelegateMock: EmptyDataViewDelegate {
    var view: EmptyDataView?
    
    // MARK: - EmptyDataViewDelegate
    
    func emptyDataViewDidTapButton(_ view: EmptyDataView) {
        self.view = view
    }
}

