//
//  ExpiryDatePicker.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

enum ExpiryDateType {
    case month
    case year
}

private let kUnderlineViewAlphaDefault: CGFloat = 0.2
private let kUnderlineViewAlphaHighlighted: CGFloat = 1

class ExpiryDatePicker: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var underlineView: UIView!
    
    var pickerView = UIPickerView()
    var placeholder: String {
        return String()
    }
    
    var data: [String] {
        assert(false, "data method not implemented")
        return [String]()
    }
    
    // MARK: - initialization
    init() {
        super.init(frame: CGRect.zero)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: ExpiryDatePicker.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupViews()
    }
    
    private func setupViews() {
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.white
        dateTextField.tintColor = UIColor.white
        dateTextField?.attributedPlaceholder = NSAttributedString(string: placeholder.uppercased(), attributes: [NSForegroundColorAttributeName: UIColor.black])
        dateTextField?.inputView = pickerView
        underlineView.alpha = kUnderlineViewAlphaDefault
        addToolbar()
    }
    
    private func addToolbar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.backgroundColor = UIColor.white
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        dateTextField.inputAccessoryView = toolBar
    }
    
    // MARK: - actions
    @objc private func doneTapped() {
        dateTextField.text = data[pickerView.selectedRow(inComponent: 0)]
        dateTextField.endEditing(true)
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    @IBAction func textFieldEditingDidBegin(_ sender: UITextField) {
        underlineView.alpha = kUnderlineViewAlphaHighlighted
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: UITextField) {
        underlineView.alpha = kUnderlineViewAlphaDefault
    }
}
