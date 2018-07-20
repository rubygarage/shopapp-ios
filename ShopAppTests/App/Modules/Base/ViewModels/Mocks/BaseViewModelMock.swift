//
//  BaseViewModelMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class BaseViewModelMock: BaseViewModel {
    func setContentState() {
        state.onNext(ViewState.content)
    }
    
    func setEmptyState() {
        state.onNext(ViewState.empty)
    }
    
    func setLoadingState(showHud: Bool = true, isTranslucent: Bool = false) {
        let state = ViewState.loading(showHud: showHud, isTranslucent: isTranslucent)
        self.state.onNext(state)
    }
    
    func setEmptyErrorState() {
        let state = ViewState.error(error: nil)
        self.state.onNext(state)
    }
    
    func setContentErrorState() {
        let error = ShopAppError.content(isNetworkError: false)
        let state = ViewState.error(error: error)
        self.state.onNext(state)
    }
    
    func setNetworkErrorState() {
        let error = ShopAppError.content(isNetworkError: true)
        let state = ViewState.error(error: error)
        self.state.onNext(state)
    }
    
    func setNonCriticalErrorState() {
        let error = ShopAppError.nonCritical(message: "message")
        let state = ViewState.error(error: error)
        self.state.onNext(state)
    }
    
    func setCriticalErrorState() {
        let error = ShopAppError.critical
        let state = ViewState.error(error: error)
        self.state.onNext(state)
    }
}
