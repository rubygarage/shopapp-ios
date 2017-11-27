//
//  UIViewControllerAlert.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/9/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

enum AlertButtonIndex: Int {
    case submit = 0
    case cancel = 1
}

typealias ButtonClosure = (_ buttonIndex: Int) -> ()
typealias AlertClosure = (AlertButtonIndex) -> ()

extension UIViewController {
    // MARK: - public
    func showErrorAlert(with message: String?, handler: AlertClosure? = nil) {
        let title = NSLocalizedString("Alert.Error", comment: String())
        let cancel = NSLocalizedString("Button.Ok", comment: String())
        showAlertController(with: title, message: message, cancel: cancel, handler: handler)
    }
    
    func showAlert(with title: String?, message: String?, submit: String, handler: @escaping AlertClosure) {
        let cancel = NSLocalizedString("Button.Cancel", comment: String())
        showAlertController(with: title, message: message, submit: submit, cancel: cancel, handler: handler)
    }
    
    func showActionSheet(with title: String?, message: String? = nil, buttons: [String], destructive: String? = nil, cancel: String, handle: @escaping ButtonClosure) {
        showController(with: title, message: message, style: .actionSheet, buttons: buttons, destructive: destructive, cancel: cancel, handle: handle)
    }
    
    // MARK: - private
    private func showAlertController(with title: String?, message: String?, submit: String? = nil, cancel: String, handler: AlertClosure?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancel, style: .default) { (action) in
            handler?(.cancel)
        }
        alertController.addAction(cancelAction)
        if submit != nil {
            let submitAction = UIAlertAction(title: submit, style: .default, handler: { (action) in
                handler?(.submit)
            })
            alertController.addAction(submitAction)
        }
        present(alertController, animated: true)
    }
    
    private func showController(with title: String?, message: String?, style: UIAlertControllerStyle, buttons: [String], destructive: String?, cancel: String?, handle: @escaping ButtonClosure) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        if let destructive = destructive {
            let alertAction = UIAlertAction(title: destructive, style: .destructive,
                                            handler: { (action: UIAlertAction) -> () in
                                                handle(buttons.count)
            })
            alertController.addAction(alertAction)
        }
        
        if buttons.count > 0 {
            for title in buttons {
                let alertAction = UIAlertAction(title: title, style: .default,
                                                handler: { (action: UIAlertAction) -> () in
                                                    let index = buttons.index(of: action.title!)
                                                    handle(index!)
                })
                alertController.addAction(alertAction)
            }
        }
        
        if let cancel = cancel {
            let alertAction = UIAlertAction(title: cancel, style: .cancel)
            alertController.addAction(alertAction)
        }
        
        self.present(alertController, animated: true)
    }
}
