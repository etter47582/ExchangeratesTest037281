//
//  Extension_UIViewController.swift
//  ExchangeratesTest037281
//
//  Created by Vladyslav Veretennikov on 03.11.2023.
//

import UIKit

extension UIViewController {
    func showErrorAlert(with title: String = "Some was wrong...", and message: String) {
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(settingsAction)
        present(alertController, animated: true)
    }
}
