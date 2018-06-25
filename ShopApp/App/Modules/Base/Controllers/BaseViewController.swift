//
//  BaseViewController.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/1/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import ShopApp_Gateway
import Toaster

enum ViewState: Equatable {
    case loading(showHud: Bool, isTranslucent: Bool)
    case content
    case error(error: ShopAppError?)
    case empty
    
    enum Builder {
        static func loading(showHud: Bool = true, isTranslucent: Bool = false) -> ViewState {
            return ViewState.loading(showHud: showHud, isTranslucent: isTranslucent)
        }
    }

    static var make: ViewState.Builder.Type {
        return ViewState.Builder.self
    }
    
    // MARK: - Equatable
    
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.content, .content), (.error, .error), (.empty, .empty):
            return true
        default:
            return false
        }
    }
}

class BaseViewController<T: BaseViewModel>: UIViewController, ErrorViewDelegate, CriticalErrorViewDelegate {
    private let loadingViewFillAlpha: CGFloat = 1
    private let loadingViewTranslucentAlpha: CGFloat = 0.75
    private let toastBottomOffset: CGFloat = 80
    private let toastDuration: TimeInterval = 3
    
    private var emptyDataView: UIView!
    
    private(set) var disposeBag = DisposeBag()
    private(set) var loadingView = LoadingView()
    private(set) var errorView = ErrorView()
    private(set) var criticalErrorView = CriticalErrorView()
    
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
        let toast = Toast(text: message, duration: toastDuration)
        toast.show()
    }
    
    private func setupViews() {
        addBackButtonIfNeeded()
        emptyDataView = customEmptyDataView

        errorView.delegate = self
        criticalErrorView.delegate = self
        
        switch self {
        case is ProductDetailsViewController:
            criticalErrorView.itemType = .product
        case is CategoryViewController:
            criticalErrorView.itemType = .category
        case is ArticleDetailsViewController:
            criticalErrorView.itemType = .article
        case is OrderDetailsViewController:
            criticalErrorView.itemType = .order
        default:
            criticalErrorView.itemType = .default
        }
        
        ToastView.appearance().bottomOffsetPortrait = toastBottomOffset
    }
    
    private func subscribeViewState() {
        viewModel?.state
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
            loadingView.alpha = isTranslucent ? loadingViewTranslucentAlpha : loadingViewFillAlpha
            addSubviewAndConstraints(subview: loadingView)
        }
    }
    
    private func setContentState() {
        errorView.removeFromSuperview()
        loadingView.removeFromSuperview()
        emptyDataView.removeFromSuperview()
    }
    
    private func setErrorState(with error: ShopAppError?) {
        guard let error = error else {
            processDefaultError()
            
            return
        }
        
        switch error {
        case .critical:
            processCriticalError()
        case .nonCritical(let message):
            processNonCriticalError(with: message)
        case .content(let isNetworkError):
            processContentError(isNetworkError)
        }
    }
    
    private func setEmptyState() {
        errorView.removeFromSuperview()
        criticalErrorView.removeFromSuperview()
        loadingView.removeFromSuperview()
        addSubviewAndConstraints(subview: emptyDataView)
    }
    
    private func processCriticalError() {
        errorView.removeFromSuperview()
        loadingView.removeFromSuperview()
        emptyDataView.removeFromSuperview()
        addSubviewAndConstraints(subview: criticalErrorView)
    }

    private func processNonCriticalError(with message: String) {
        loadingView.removeFromSuperview()
        showToast(with: message)
    }
    
    private func processContentError(_ isNetworkError: Bool) {
        loadingView.removeFromSuperview()
        criticalErrorView.removeFromSuperview()
        errorView.isNetworkError = isNetworkError
        addSubviewAndConstraints(subview: errorView)
    }

    private func processDefaultError() {
        loadingView.removeFromSuperview()
    }

    // MARK: - Subviews

    private func addSubviewAndConstraints(subview: UIView) {
        view.addSubview(subview)

        subview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        subview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        subview.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        subview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        subview.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - ErrorViewDelegate

    func viewDidTapTryAgain(_ view: ErrorView) {
        viewModel?.tryAgain()
    }
    
    // MARK: - CriticalErrorViewDelegate
    
    func criticalErrorViewDidTapBack(_ view: CriticalErrorView) {
        navigationController?.popViewController(animated: true)
    }
}
