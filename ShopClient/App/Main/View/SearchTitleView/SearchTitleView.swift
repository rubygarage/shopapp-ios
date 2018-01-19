//
//  SearchTitleView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

enum SearchState {
    case `default`
    case editing
}

protocol SearchTitleViewProtocol: class {
    func didTapSearch()
    func didTapCart()
    func didTapBack()
    func didStartEditing()
    func didTapClear()
}

private let kAnimationDuration: TimeInterval = 0.3
private let kPlaceholderColorDefault = UIColor.black.withAlphaComponent(0.5)
private let kUnderlineMarginDefault: CGFloat = 55
private let kUnderlineMarginLeft: CGFloat = 40
private let kUnderlineMarginRight: CGFloat = 10
private let kBarItemWidth: CGFloat = 32

class SearchTitleView: UIView, UITextFieldDelegate {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cartButtonView: UIView!
    @IBOutlet weak var underlineLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var underlineRightMargin: NSLayoutConstraint!
    @IBOutlet weak var clearButton: UIButton!
    
    weak var delegate: SearchTitleViewProtocol?
    
    var state: SearchState = .default {
        didSet {
            updateViews(animated: true)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return UILayoutFittingExpandedSize
    }
    
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
    
    func updateCartBarItem() {
        cartButtonView.subviews.forEach({ $0.removeFromSuperview() })
        cartButtonView.addSubview(cartBarItem())
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: SearchTitleView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupViews()
    }
    
    private func setupViews() {
        searchTextField.delegate = self
        clearButton.setTitle("Button.Clear".localizable, for: .normal)
    }
    
    private func updateViews(animated: Bool) {
        let animationDuration = animated ? kAnimationDuration : 0
        UIView.transition(with: contentView, duration: animationDuration, options: .transitionCrossDissolve, animations: {
            self.searchTextField.attributedPlaceholder = self.state == .default ? self.attributedPlaceholderDefault() : self.attributedPlaceholderSelected()
            self.searchTextField.textAlignment = self.state == .editing ? .left : .center
        })
        
        UIView.animate(withDuration: kAnimationDuration) {
            self.underLineView.backgroundColor = self.state == .editing ? UIColor.black : UIColor.underlineDefault
            self.underlineLeftMargin.constant = self.state == .editing ? kUnderlineMarginLeft : kUnderlineMarginDefault
            self.underlineRightMargin.constant = self.state == .editing ? kUnderlineMarginRight : kUnderlineMarginDefault
            self.backButton.isHidden = self.state == .default
            self.cartButtonView.isHidden = self.state == .editing
            self.layoutIfNeeded()
        }
    }
    
    private func attributedPlaceholderDefault() -> NSAttributedString {
        let placeholder = "Placeholder.Search".localizable
        let attributedPlaceholder = NSMutableAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor.black])
        let textAttachment = NSTextAttachment()
        textAttachment.image = #imageLiteral(resourceName: "search")
        let deltaY = (searchTextField.font!.capHeight - #imageLiteral(resourceName: "search").size.height).rounded() / 2
        textAttachment.bounds = CGRect(x: 0, y: deltaY, width: #imageLiteral(resourceName: "search").size.width, height: #imageLiteral(resourceName: "search").size.height)
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        attributedPlaceholder.replaceCharacters(in: NSRange(location: 0, length: 0), with: attrStringWithImage)
        return attributedPlaceholder
    }
    
    private func attributedPlaceholderSelected() -> NSAttributedString {
        let placeholder = "Placeholder.Search".localizable
        return NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: kPlaceholderColorDefault])
    }
    
    private func updateClearButtonIfNeeded() {
        let text = searchTextField.text ?? ""
        let clearButtonHidden = !(text.isEmpty == false && state == .editing)
        if clearButton.isHidden != clearButtonHidden {
            UIView.transition(with: contentView, duration: kAnimationDuration, options: .transitionCrossDissolve, animations: {
                self.clearButton.isHidden = clearButtonHidden
            })
        }
    }
    
    // MARK: - actions
    @IBAction func searchTextFieldEditingDidBegin(_ sender: UITextField) {
        state = .editing
        updateClearButtonIfNeeded()
        delegate?.didStartEditing()
    }
    
    @IBAction func searchTextFieldEditingDidEnd(_ sender: UITextField) {
        state = .default
        updateClearButtonIfNeeded()
    }
    
    @IBAction func searchTextFieldEditingChanged(_ sender: UITextField) {
        updateClearButtonIfNeeded()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        endEditing(true)
        searchTextField.text = nil
        delegate?.didTapBack()
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        searchTextField.text = nil
        updateClearButtonIfNeeded()
        delegate?.didTapClear()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view != searchTextField {
            searchTextField.endEditing(true)
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.didTapSearch()
        return true
    }
}

internal extension SearchTitleView {
    func cartBarItem() -> UIButton {
        let cartView = CartButtonView(frame: CGRect(x: 0, y: 0, width: kBarItemWidth, height: kBarItemWidth))
        cartView.isUserInteractionEnabled = false
        
        let button = UIButton(frame: cartView.frame)
        button.addSubview(cartView)
        button.addTarget(self, action: #selector(self.cartButtonHandler), for: .touchUpInside)
        
        return button
    }
    
    @objc private func cartButtonHandler() {
        delegate?.didTapCart()
    }
}
