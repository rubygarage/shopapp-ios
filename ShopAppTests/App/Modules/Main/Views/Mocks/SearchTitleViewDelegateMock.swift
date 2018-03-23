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
    var isViewDidBeginEditing = false
    var isViewDidChangeSearchPhrase = false
    var isViewDidTapClear = false
    var isViewDidTapBack = false
    var isViewDidTapCart = false
    
    // MARK: - SearchTitleViewDelegate
    
    func viewDidBeginEditing(_ view: SearchTitleView) {
        isViewDidBeginEditing = true
        self.view = view
    }
    
    func viewDidChangeSearchPhrase(_ view: SearchTitleView) {
        isViewDidChangeSearchPhrase = true
        self.view = view
    }
    
    func viewDidTapClear(_ view: SearchTitleView) {
        isViewDidTapClear = true
        self.view = view
    }
    
    func viewDidTapBack(_ view: SearchTitleView) {
        isViewDidTapBack = true
        self.view = view
    }
    
    func viewDidTapCart(_ view: SearchTitleView) {
        isViewDidTapCart = true
        self.view = view
    }
}
