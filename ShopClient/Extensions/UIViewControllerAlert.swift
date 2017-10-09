//
//  UIViewControllerAlert.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/9/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

extension UIViewController {
    func showErrorAlert(with message: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        let title = NSLocalizedString("Alert.Error", comment: String())
        showAlertController(with: title, message: message, handler: handler)
    }
    
    private func showAlertController(with title: String?, message: String?, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelTitle = NSLocalizedString("Button.Ok", comment: String())
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: handler)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
