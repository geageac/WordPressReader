//
//  Firebase.swift
//  LNPopupControllerExample
//
//  Created by Tezz on 1/7/20.
//  Copyright © 2020 Leo Natan. All rights reserved.
//

import Foundation
import Firebase
import SPAlert

var handle : AuthStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
    if isUserLoggedIn() {
        let alertView = SPAlertView(title: "Logged In Succcessfully", message: nil, preset: SPAlertPreset.done)
        alertView.duration = 3
        alertView.present()
    }
}

func parseError(_ error: Error) -> String {
    var e = "Couldn't parse error"
    if let errorCode = AuthErrorCode(rawValue: error._code) {
        e = errorCode.errorMessage
    }
    return e
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password"
        default:
            return "Unknown error occurred"
        }
    }
}

extension UIViewController {
    func showErrorMessage(errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSuccessMessage(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func loggedInPrompt() {
    }

}
