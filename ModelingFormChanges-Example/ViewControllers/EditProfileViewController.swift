//
//  EditProfileViewController.swift
//  ModelingFormChanges-Example
//
//  Created by William Boles on 10/12/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    lazy var validator: EditProfileValidator = {
        let validator = EditProfileValidator(user: self.user)
        return validator
    }()
    
    lazy var user: User = {
        let user = User(username: "Tom")
        return user
    }()
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
     
        clearAllErrors()
        
        firstNameTextField.text = user.username
    }
    
    // MARK: - ButtonActions
    
    @IBAction func updateButtonPressed(_ sender: Any) {
        view.endEditing(true)
        
        if validator.hasMadeChanges() {
            switch validator.validateAccountDetails() {
            case .success:
                let alertController = UIAlertController(title: "Save Changes", message: "Can successfully save changes: \n \(validator.changes())", preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(dismissAction)
                
                present(alertController, animated: true, completion: nil)
            case .failure(let accountValidationErrorMessages):
                if accountValidationErrorMessages.usernameLocalizedErrorMessage != nil {
                    showError(textField: firstNameTextField, messagelabel: firstNameErrorLabel, message: accountValidationErrorMessages.usernameLocalizedErrorMessage!)
                }
            }
        } else {
            let alertController = UIAlertController(title: "No Changes", message: "You haven't made any changes to update", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alertController.addAction(dismissAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Error
    
    func showError(textField: UITextField, messagelabel: UILabel, message: String) {
        textField.textColor = UIColor.red
        messagelabel.text = message
        messagelabel.superview?.isHidden = false
    }
    
    func hideErrorMessage(messagelabel: UILabel) {
        messagelabel.superview?.isHidden = true
    }
    
    func clearAllErrors() {
        hideErrorMessage(messagelabel: firstNameErrorLabel)
    }
    
    // MARK: - Keyboard
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo
        let rect = (info![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let duration = (info![UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        let option = UIView.AnimationOptions(rawValue: UInt((notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey]! as AnyObject).integerValue << 16))
        
        UIView.animate(withDuration: duration!, delay: 0, options: option, animations: {
            let keyboardHeight = self.view.convert(rect!, to: nil).size.height
            self.scrollViewBottomConstraint?.constant = keyboardHeight
            self.scrollView.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let info = notification.userInfo
        let duration = (info![UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        let option = UIView.AnimationOptions(rawValue: UInt((notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey]! as AnyObject).integerValue << 16))
        UIView.animate(withDuration: duration!, delay: 0, options: option, animations: {
            self.scrollViewBottomConstraint?.constant = 0
            self.scrollView.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - Gesture
    
    @IBAction func backgroundTapped(_ sender: Any) {
        view.endEditing(true)
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
        
        scrollView.setContentOffset(CGPoint.init(x: 0, y: textField.superview!.frame.origin.y), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == firstNameTextField {
            validator.username = textField.text
            
            switch validator.validateUsername() {
            case .success:
                hideErrorMessage(messagelabel: firstNameErrorLabel)
                break
            case .failure(let localizedErrorMessage):
                showError(textField: textField, messagelabel: firstNameErrorLabel, message: localizedErrorMessage)
            }
        }
    }
}

