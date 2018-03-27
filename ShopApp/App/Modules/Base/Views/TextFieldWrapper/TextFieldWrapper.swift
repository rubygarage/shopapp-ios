//
//  TextFieldWrapper.swift
//  ShopApp
//
//  Created by Mykola Voronin on 1/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class TextFieldWrapper: UIView {
    // swiftlint:disable private_outlet
    @IBOutlet private(set) weak var textField: UITextField!
    // swiftlint:enable private_outlet

    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    // MARK: - Setup
    
    func setTextFieldEnabled(_ isEnabled: Bool) {
        textField.isEnabled = isEnabled
    }
}

// MARK: - Reactive

extension Reactive where Base: TextFieldWrapper {
    var value: ControlProperty<String?> {
        return base.textField.rx.text
    }
}
