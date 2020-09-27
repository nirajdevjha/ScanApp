//
//  UIAlertController+Error.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 27/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

extension UIAlertController {
    class func showErrorAlert(
        from viewController: UIViewController?,
        title: String, msg: String) {
        
        guard let viewController = viewController else { return }
        
        
        let okAction = UIAlertAction(
            title: "Ok",
            style: .default)
        
        let alertController = UIAlertController(
            title: title,
            message: msg,
            preferredStyle: .alert)
        
        alertController.addAction(okAction)

        viewController.present(alertController, animated: true)
        
    }
}
