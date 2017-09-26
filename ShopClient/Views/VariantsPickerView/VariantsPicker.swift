//
//  VariantsPicker.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol VariantsPickerProtocol {
    func didSelect(index: Int)
}

let kPickerViewHeight: CGFloat = 200
let kPickerRowHeight: CGFloat = 50
let kScreenWidth = UIScreen.main.bounds.size.width

class VariantsPicker: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var picker: UIPickerView?
    var variants = [ProductVariant]()
    var currency: String?
    var textField: UITextField?
    var delegate: VariantsPickerProtocol?
    
    init(variants: [ProductVariant], currency: String?, textField: UITextField, delegate: VariantsPickerProtocol) {
        super.init()
        
        self.variants = variants
        self.currency = currency
        self.textField = textField
        self.delegate = delegate
        
        setupUI()
    }
    
    // MARK: - setup
    private func setupUI() {
        let pickerFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kPickerViewHeight)
        picker = UIPickerView(frame: pickerFrame)
        picker?.backgroundColor = UIColor.white
        picker?.showsSelectionIndicator = true
        picker?.dataSource = self
        picker?.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(VariantsPicker.doneHandler))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(VariantsPicker.cancelHandler))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField?.inputView = picker
        textField?.inputAccessoryView = toolBar
    }
    
    // MARK: - actions
    func doneHandler() {
        let index = picker?.selectedRow(inComponent: 0) ?? 0
        delegate?.didSelect(index: index)
        textField?.resignFirstResponder()
    }
    
    func cancelHandler() {
        textField?.resignFirstResponder()
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return variants.count
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let rowFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kPickerRowHeight)
        
        return VariantPickerRowView(frame: rowFrame, variant: variants[row], currency: currency)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return kPickerRowHeight
    }
}
