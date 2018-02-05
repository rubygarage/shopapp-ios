//
//  BaseViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/1/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import Toaster

private let kLoadingViewFillAlpha: CGFloat = 1
private let kLoadingViewTranslucentAlpha: CGFloat = 0.5
private let kToastBottomOffset: CGFloat = 80
private let kToastDuration: TimeInterval = 3

enum ViewState {
    case loading(showHud: Bool, isTranslucent: Bool)
    case content
    case error(error: RepoError?)
    case empty
    
    enum Builder {
        static func loading(showHud: Bool = true, isTranslucent: Bool = false) -> ViewState {
            return ViewState.loading(showHud: showHud, isTranslucent: isTranslucent)
        }
    }

    static var make: ViewState.Builder.Type {
        return ViewState.Builder.self
    }
}

class BaseViewController<T: BaseViewModel>: UIViewController {
    private var emptyDataView: UIView!
    
    private(set) var disposeBag = DisposeBag()
    private(set) var loadingView = LoadingView()
    private(set) var errorView = ErrorView()
    
    var viewModel: T!

    var customEmptyDataView: UIView {
        return UIView()
    }
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        subscribeViewState()
    }
    
    // MARK: - Setup
    
    func showToast(with message: String?) {
        let toast = Toast(text: message, duration: kToastDuration)
        toast.show()
    }
    
    private func setupViews() {
        addBackButtonIfNeeded()
        emptyDataView = customEmptyDataView
        loadingView.frame = view.frame
        errorView.frame = view.frame
        errorView.delegate = self
        ToastView.appearance().bottomOffsetPortrait = kToastBottomOffset
    }
    
    private func subscribeViewState() {
        viewModel.state
            .subscribe(onNext: { [weak self] state in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.set(state: state)
            })
            .disposed(by: disposeBag)
    }
    
    private func set(state: ViewState) {
        switch state {
        case .content:
            setContentState()
        case .error(let error):
            setErrorState(with: error)
        case .loading(let showHud, let isTranslucent):
            setLoadingState(showHud: showHud, isTranslucent: isTranslucent)
        case .empty:
            setEmptyState()
        }
    }
    
    private func setLoadingState(showHud: Bool, isTranslucent: Bool) {
        errorView.removeFromSuperview()
        emptyDataView.removeFromSuperview()
        if showHud {
            loadingView.alpha = isTranslucent ? kLoadingViewTranslucentAlpha : kLoadingViewFillAlpha
            view.addSubview(loadingView)
        }
    }
    
    private func setContentState() {
        errorView.removeFromSuperview()
        loadingView.removeFromSuperview()
        emptyDataView.removeFromSuperview()
    }
    
    private func setErrorState(with error: RepoError?) {
        if error is CriticalError {
            process(criticalError: error as? CriticalError)
        } else if error is NonCriticalError {
            process(nonCriticalError: error as? NonCriticalError)
        } else if error is ContentError {
            process(contentError: error as? ContentError)
        } else if error is NetworkError {
            process(networkError: error as? NetworkError)
        } else {
            process(defaultError: error)
        }
    }
    
    private func setEmptyState() {
        errorView.removeFromSuperview()
        loadingView.removeFromSuperview()
        view.addSubview(emptyDataView)
    }
    
    private func process(criticalError: CriticalError?) {
        loadingView.removeFromSuperview()
        showToast(with: criticalError?.errorMessage)
        if self is HomeViewController == false {
            setHomeController()
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
    
    private func process(networkError: NetworkError?) {
        loadingView.removeFromSuperview()
        errorView.error = networkError
        view.addSubview(errorView)
    }
    
    private func process(defaultError: RepoError?) {
        loadingView.removeFromSuperview()
    }
}

// MARK: - ErrorViewDelegate

extension BaseViewController: ErrorViewDelegate {
    func viewDidTapTryAgain(_ view: ErrorView) {
        viewModel.tryAgain()
    }
}
