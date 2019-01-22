//
//  Alert.swift
//  RecordAndSpeek
//
//  Created by Lucas Moraes on 22/01/19.
//  Copyright © 2019 LSolutions. All rights reserved.
//

import UIKit

class AlertService {
    static func displayDefaultMessage(in viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okBtn = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okBtn)
        viewController.present(alert, animated: true, completion: nil)
    }
}
