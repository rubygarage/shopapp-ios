
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

enum ViewState {
    case loading
    case content
    case error(RepoError?)
}

class BaseViewController<T: BaseViewModel>: UIViewController, ErrorViewProtocol {
    let disposeBag = DisposeBag()
    
    var viewModel: T!
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
        viewModel.state.subscribe(onNext: { [weak self] result in
            self?.set(state: result)
        }).disposed(by: disposeBag)
    }
    
    private func set(state: ViewState) {
        switch state {
        case .content:
            setContentState()
            break
        case .error(let error):
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
    
    private func setErrorState(with error: RepoError?) {
        loadingView.removeFromSuperview()
        errorView.error = error
        view.addSubview(errorView)
    }
}
