//
//  BaseViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/1/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum ViewState: Int {
    case loading
    case content
    case error
}

class BaseViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeViewState()
    }
    
    private func subscribeViewState() {
        viewModel().state.subscribe(onNext: { [weak self] viewState in
            self?.set(state: viewState.state, error: viewState.error)
        }).disposed(by: disposeBag)
    }
    
    private func set(state: ViewState, error: Error? = nil) {
        switch state {
        case .content:
            setContentState()
            break
        case .error:
            setErrorState(with: error)
            break
        default:
            setLoadingState()
            break
        }
    }
    
    private func setLoadingState() {
        
    }
    
    private func setContentState() {
        
    }
    
    private func setErrorState(with error: Error?) {
        
    }
    
    // MARK: - method to override
    public func viewModel() -> BaseViewModel {
        assert(false, "'viewModel method not implemented'")
    }
}
