
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
import Toaster

enum ViewState {
    case loading(showHud: Bool)
    case content
    case error(RepoError?)
}

private let kToastBottomOffset: CGFloat = 80
private let kToastDuration: TimeInterval = 3

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
        
        ToastView.appearance().bottomOffsetPortrait = kToastBottomOffset
    }
    
    private func subscribeViewState() {
        viewModel.state.subscribe(onNext: { [weak self] state in
            self?.set(state: state)
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
        case .loading(let showHud):
            setLoadingState(showHud: showHud)
            break
        }
    }
    
    private func setLoadingState(showHud: Bool) {
        errorView.removeFromSuperview()
        if showHud {
            view.addSubview(loadingView)
        }
    }
    
    private func setContentState() {
        errorView.removeFromSuperview()
        loadingView.removeFromSuperview()
    }
    
    private func setErrorState(with error: RepoError?) {
        if error is CriticalError {
            process(criticalError: error as? CriticalError)
        } else if error is NonCriticalError {
            process(nonCriticalError: error as? NonCriticalError)
        } else if error is ContentError {
            process(contentError: error as? ContentError)
        } else {
            process(defaultError: error)
        }
    }
    
    private func process(criticalError: CriticalError?) {
        showToast(with: criticalError?.errorMessage)
        if self is HomeViewController == false {
            setHomeController()
        } else {
            loadingView.removeFromSuperview()
        }
    }
    
    private func process(nonCriticalError: NonCriticalError?) {
        loadingView.removeFromSuperview()
        showToast(with: nonCriticalError?.errorMessage)
    }
    
    private func process(contentError: ContentError?) {
        loadingView.removeFromSuperview()
        errorView.error = contentError
        view.addSubview(errorView)
    }
    
    private func process(defaultError: RepoError?) {
        loadingView.removeFromSuperview()
    }
    
    private func showToast(with message: String?) {
        let toast = Toast(text: message, duration: kToastDuration)
        toast.show()
    }
}
