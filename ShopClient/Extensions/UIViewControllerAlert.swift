//
//  UIViewControllerAlert.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/9/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

typealias ButtonClosure = (_ buttonIndex: Int) -> ()

extension UIViewController {
    // MARK: - public
    public func showErrorAlert(with message: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        let title = NSLocalizedString("Alert.Error", comment: String())
        showAlertController(with: title, message: message, handler: handler)
    }
    
    func showActionSheet(with title: String?, message: String? = nil, buttons: [String], destructive: String? = nil, cancel: String, handle: @escaping ButtonClosure) {
        showController(with: title, message: message, style: .actionSheet, buttons: buttons, destructive: destructive, cancel: cancel, handle: handle)
    }
    
    // MARK: - private
    private func showAlertController(with title: String?, message: String?, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelTitle = NSLocalizedString("Button.Ok", comment: String())
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: handler)
        alertController.addAction(cancelAction)
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
