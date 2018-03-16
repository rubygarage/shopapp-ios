//
//  SearchTitleViewDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/15/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class SearchTitleViewDelegateMock: SearchTitleViewDelegate {
    var view: SearchTitleView?
    
    // MARK: - SearchTitleViewDelegate
    
    func viewDidBeginEditing(_ view: SearchTitleView) {
        self.view = view
    }
    
    func viewDidChangeSearchPhrase(_ view: SearchTitleView) {
        self.view = view
    }
    
    func viewDidTapClear(_ view: SearchTitleView) {
        self.view = view
    }
    
    func viewDidTapBack(_ view: SearchTitleView) {
        self.view = view
    }
    
    func viewDidTapCart(_ view: SearchTitleView) {
        self.view = view
    }
}
