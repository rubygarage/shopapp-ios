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
    
    func setRepoErrorState() {
        let error = RepoError()
        let state = ViewState.error(error: error)
        self.state.onNext(state)
    }
    
    func setContentErrorState() {
        let error = ContentError()
        let state = ViewState.error(error: error)
        self.state.onNext(state)
    }
    
    func setNetworkErrorState() {
        let error = NetworkError()
        let state = ViewState.error(error: error)
        self.state.onNext(state)
    }
    
    func setNonCriticalErrorState() {
        let error = NonCriticalError()
        let state = ViewState.error(error: error)
        self.state.onNext(state)
    }
    
    func setCriticalErrorState() {
        let error = CriticalError(with: nil, message: "")
        let state = ViewState.error(error: error)
        self.state.onNext(state)
    }
}
