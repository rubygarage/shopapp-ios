//
//  ExpiryDatePicker.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

private let kUnderlineViewAlphaDefault: CGFloat = 0.2
private let kUnderlineViewAlphaHighlighted: CGFloat = 1
private let kUnderlineViewHeightDefault: CGFloat = 1
private let kUnderlineViewHeightHighlighted: CGFloat = 2

class BasePicker: PlaceholderedTextField {
    @IBOutlet private weak var underlineView: UIView!
    @IBOutlet private weak var underlineViewHeight: NSLayoutConstraint!
    
    private var customData: [String]?

    var pickerView = UIPickerView()
    
    var initialPlaceholder: String {
        return ""
    }
    var data: [String] {
        return customData ?? []
    }
    
    override var text: String? {
        didSet {
            setPlaceholderPosition()
        }
    }
    
    // MARK: - View lifecycle
    
    init() {
        super.init(frame: .zero)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        let nibName = String(describing: BasePicker.self)
        loadFromNib(with: nibName)
        setupViews()
    }
    
    // MARK: - Setup
    
    func setCustomData(_ data: [String]) {
        customData = data
        pickerView.reloadAllComponents()
    }
    
    private func setupViews() {
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = .white
        textField.tintColor = .clear
        textField.inputView = pickerView
        placeholderLabel.text = initialPlaceholder.uppercased()
        underlineView.alpha = kUnderlineViewAlphaDefault
        addToolbar()
    }
    
    private func addToolbar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.backgroundColor = .white
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Button.Done".localizable, style: .plain, target: self, action: #selector(doneButtonDidPress))
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
    }
    
    // MARK: - Actions
    
    @objc private func doneButtonDidPress() {
        textField.text = data[pickerView.selectedRow(inComponent: 0)]
        textField.endEditing(true)
        if placeholderVerticallyConstraint.constant == 0 {
            updatePlaceholderPosition(toTop: true, animated: true)
        }
    }
    
    @IBAction func textFieldEditingDidBegin(_ sender: UITextField) {
        underlineView.alpha = kUnderlineViewAlphaHighlighted
        underlineViewHeight.constant = kUnderlineViewHeightHighlighted
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: UITextField) {
        underlineView.alpha = kUnderlineViewAlphaDefault
        underlineViewHeight.constant = kUnderlineViewHeightDefault
    }
}

// MARK: - UIPickerViewDataSource

extension BasePicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
}

// MARK: - UIPickerViewDelegate

extension BasePicker: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
}
