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

class BaseViewController<T: BaseViewModel>: UIViewController, ErrorViewProtocol {
    var viewModel: T!
    var disposeBag = DisposeBag()
    var loadingView = LoadingView()
    var errorView = ErrorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        subscribeViewState()
    }
    
    private func setupViews() {
        loadingView.frame = view.frame
        errorView.frame = view.frame
        errorView.delegate = self
    }
    
    private func subscribeViewState() {
        viewModel.state.subscribe(onNext: { [weak self] viewState in
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
        errorView.removeFromSuperview()
        view.addSubview(loadingView)
    }
    
    private func setContentState() {
        errorView.removeFromSuperview()
        loadingView.removeFromSuperview()
    }
    
    private func setErrorState(with error: Error?) {
        loadingView.removeFromSuperview()
        errorView.error = error
        view.addSubview(errorView)
    }
}
