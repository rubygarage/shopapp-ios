//
//  SearchTitleView.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 12/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import RxSwift

private enum SearchState {
    case `default`
    case editing
}

protocol SearchTitleViewDelegate: class {
    func viewDidBeginEditing(_ view: SearchTitleView)
    func viewDidChangeSearchPhrase(_ view: SearchTitleView)
    func viewDidTapClear(_ view: SearchTitleView)
    func viewDidTapBack(_ view: SearchTitleView)
    func viewDidTapCart(_ view: SearchTitleView)
}

class SearchTitleView: TextFieldWrapper {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var underLineView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var cartButtonView: UIView!
    @IBOutlet private weak var underlineLeftMargin: NSLayoutConstraint!
    @IBOutlet private weak var underlineRightMargin: NSLayoutConstraint!
    @IBOutlet private weak var clearButton: UIButton!

    private let animationDuration: TimeInterval = 0.3
    private let placeholderColorDefault = UIColor.black.withAlphaComponent(0.5)
    private let underlineMarginDefault: CGFloat = 55
    private let underlineMarginLeft: CGFloat = 40
    private let underlineMarginRight: CGFloat = 10
    private let textFieldDebounceDueTime = 0.3
    private let barItemWidth: CGFloat = 32
    private let disposeBag = DisposeBag()
    
    private var previousSearchPhrase: String?
    
    private var state: SearchState = .default {
        didSet {
            updateViews(animated: true)
        }
    }
    
    weak var delegate: SearchTitleViewDelegate?
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    // MARK: - View lifecycle
    
    init() {
        super.init(frame: CGRect.zero)
        
        commonInit()
        updateViews(animated: false)
        updateClearButtonIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
        updateViews(animated: false)
        updateClearButtonIfNeeded()
    }
    
    // MARK: - Setup
    
    func updateCartBarItem() {
        cartButtonView.subviews.forEach({ $0.removeFromSuperview() })
        cartButtonView.addSubview(cartBarItem())
    }
    
    private func commonInit() {
        loadFromNib()
        setupViews()
    }
    
    private func setupViews() {
        clearButton.setTitle("Button.Clear".localizable, for: .normal)
        
        textField.rx.text
            .skip(1)
            .debounce(textFieldDebounceDueTime, scheduler: MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let strongSelf = self, let delegate = strongSelf.delegate else {
                    return
                }
                if let previousSearchPhrase = strongSelf.previousSearchPhrase, text != previousSearchPhrase {
                    delegate.viewDidChangeSearchPhrase(strongSelf)
                }
                strongSelf.previousSearchPhrase = text
            })
            .disposed(by: disposeBag)
    }
    
    private func updateViews(animated: Bool) {
        let animationDuration = animated ? self.animationDuration : 0
        
        UIView.transition(with: contentView, duration: animationDuration, options: .transitionCrossDissolve, animations: {
            self.textField.attributedPlaceholder = self.state == .default ? self.attributedPlaceholderDefault() : self.attributedPlaceholderSelected()
            self.textField.textAlignment = self.state == .editing ? .left : .center
        })
        
        UIView.animate(withDuration: animationDuration) {
            self.underLineView.backgroundColor = self.state == .editing ? UIColor.black : Colors.underlineDefault
            self.underlineLeftMargin.constant = self.state == .editing ? self.underlineMarginLeft : self.underlineMarginDefault
            self.underlineRightMargin.constant = self.state == .editing ? self.underlineMarginRight : self.underlineMarginDefault
            self.backButton.isHidden = self.state == .default
            self.cartButtonView.isHidden = self.state == .editing
            self.layoutIfNeeded()
        }
    }
    
    private func attributedPlaceholderDefault() -> NSAttributedString {
        let placeholder = "Placeholder.Search".localizable
        let attributedPlaceholder = NSMutableAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        let textAttachment = NSTextAttachment()
        textAttachment.image = #imageLiteral(resourceName: "search")
        let deltaY = (textField.font!.capHeight - #imageLiteral(resourceName: "search").size.height).rounded() / 2
        textAttachment.bounds = CGRect(x: 0, y: deltaY, width: #imageLiteral(resourceName: "search").size.width, height: #imageLiteral(resourceName: "search").size.height)
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        attributedPlaceholder.replaceCharacters(in: NSRange(location: 0, length: 0), with: attrStringWithImage)
        return attributedPlaceholder
    }
    
    private func attributedPlaceholderSelected() -> NSAttributedString {
        let placeholder = "Placeholder.Search".localizable
        return NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: placeholderColorDefault])
    }
    
    private func updateClearButtonIfNeeded() {
        let text = textField.text ?? ""
        let clearButtonHidden = !(text.isEmpty == false && state == .editing)
        if clearButton.isHidden != clearButtonHidden {
            UIView.transition(with: contentView, duration: animationDuration, options: .transitionCrossDissolve, animations: {
                self.clearButton.isHidden = clearButtonHidden
            })
        }
    }
    
    private func cartBarItem() -> UIButton {
        let cartView = CartButtonView(frame: CGRect(x: 0, y: 0, width: barItemWidth, height: barItemWidth))
        cartView.isUserInteractionEnabled = false
        
        let button = UIButton(frame: cartView.frame)
        button.addSubview(cartView)
        button.addTarget(self, action: #selector(cartButtonDidPress), for: .touchUpInside)
        
        return button
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonDidPress(_ sender: UIButton) {
        state = .default
        updateClearButtonIfNeeded()
        endEditing(true)
        textField.text = nil
        delegate?.viewDidTapBack(self)
    }
    
    @IBAction func searchTextFieldEditingDidBegin(_ sender: UITextField) {
        state = .editing
        updateClearButtonIfNeeded()
        delegate?.viewDidBeginEditing(self)
    }
    
    @IBAction func searchTextFieldEditingDidChange(_ sender: UITextField) {
        updateClearButtonIfNeeded()
    }
    
    @IBAction func searchTextFieldEditingDidEnd(_ sender: UITextField) {
        updateClearButtonIfNeeded()
    }
    
    @IBAction func clearButtonDidPress(_ sender: UIButton) {
        textField.text = nil
        updateClearButtonIfNeeded()
        delegate?.viewDidTapClear(self)
    }
    
    @objc private func cartButtonDidPress() {
        delegate?.viewDidTapCart(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view != textField {
            textField.endEditing(true)
        }
    }
}
