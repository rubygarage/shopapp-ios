//
//  ExpiryDatePicker.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class BasePicker: PlaceholderedTextField {
    @IBOutlet private weak var underlineView: UIView!
    @IBOutlet private weak var underlineViewHeight: NSLayoutConstraint!
    
    private let underlineViewAlphaDefault: CGFloat = 0.2
    private let underlineViewAlphaHighlighted: CGFloat = 1
    private let underlineViewHeightDefault: CGFloat = 1
    private let underlineViewHeightHighlighted: CGFloat = 2

    var pickerView = UIPickerView()
    
    var customData: [String]? {
        didSet {
            pickerView.reloadAllComponents()
            if let customData = customData, let text = text {
                pickerView.selectRow(customData.index(of: text) ?? 0, inComponent: 0, animated: false)
            }
        }
    }
    
    var initialPlaceholder: String {
        return ""
    }
    var data: [String] {
        return customData ?? []
    }
    
    override var text: String? {
        didSet {
            guard let text = text else {
                return
            }
            setPlaceholderPosition()
            pickerView.selectRow(data.index(of: text) ?? 0, inComponent: 0, animated: false)
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
        loadFromNib(with: BasePicker.nameOfClass)
        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = .white
        textField.tintColor = .clear
        textField.inputView = pickerView
        placeholderLabel.text = initialPlaceholder.uppercased()
        underlineView.alpha = underlineViewAlphaDefault
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
        underlineView.alpha = underlineViewAlphaHighlighted
        underlineViewHeight.constant = underlineViewHeightHighlighted
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: UITextField) {
        underlineView.alpha = underlineViewAlphaDefault
        underlineViewHeight.constant = underlineViewHeightDefault
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
