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
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var lastNameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var ageErrorLabel: UILabel!
    
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    lazy var validator: EditProfileValidator = {
        let validator = EditProfileValidator(user: self.user)
        return validator
    }()
    
    lazy var user: User = {
        let user = User(firstName: "Tom", lastName: "Smithson", email: "tom.smithson@somewhere.com", age: 27)
        return user
    }()
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
     
        clearAllErrors()
        
        firstNameTextField.text = user.firstName
        lastNameTextField.text = user.lastName
        emailTextField.text = user.email
        ageTextField.text = "\(user.age)"
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
                if accountValidationErrorMessages.firstNameLocalizedErrorMessage != nil {
                    showError(textField: firstNameTextField, messagelabel: firstNameErrorLabel, message: accountValidationErrorMessages.firstNameLocalizedErrorMessage!)
                }
                
                if accountValidationErrorMessages.lastNameLocalizedErrorMessage != nil {
                    showError(textField: lastNameTextField, messagelabel: lastNameErrorLabel, message: accountValidationErrorMessages.lastNameLocalizedErrorMessage!)
                }
                
                if accountValidationErrorMessages.emailLocalizedErrorMessage != nil {
                    showError(textField: emailTextField, messagelabel: emailErrorLabel, message: accountValidationErrorMessages.emailLocalizedErrorMessage!)
                }
                
                if accountValidationErrorMessages.ageLocalizedErrorMessage != nil {
                    showError(textField: ageTextField, messagelabel: ageErrorLabel, message: accountValidationErrorMessages.ageLocalizedErrorMessage!)
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
        hideErrorMessage(messagelabel: lastNameErrorLabel)
        hideErrorMessage(messagelabel: emailErrorLabel)
        hideErrorMessage(messagelabel: ageErrorLabel)
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
            validator.firstName = textField.text
            
            switch validator.validateFirstName() {
            case .success:
                hideErrorMessage(messagelabel: firstNameErrorLabel)
                break
            case .failure(let localizedErrorMessage):
                showError(textField: textField, messagelabel: firstNameErrorLabel, message: localizedErrorMessage)
            }
        } else if textField == lastNameTextField {
            validator.lastName = textField.text
            
            switch validator.validateLastName() {
            case .success:
                hideErrorMessage(messagelabel: lastNameErrorLabel)
                break
            case .failure(let localizedErrorMessage):
                showError(textField: textField, messagelabel: lastNameErrorLabel, message: localizedErrorMessage)
            }
        } else if textField == emailTextField {
            validator.email = textField.text
            
            switch validator.validateEmail() {
            case .success:
                hideErrorMessage(messagelabel: emailErrorLabel)
                break
            case .failure(let localizedErrorMessage):
                showError(textField: textField, messagelabel: emailErrorLabel, message: localizedErrorMessage)
            }
        } else if textField == ageTextField {
            var age = "0"
            
            if textField.text != nil {
                age = textField.text!
            }
            
            validator.age = Int(age)
            
            switch validator.validateAge() {
            case .success:
                hideErrorMessage(messagelabel: ageErrorLabel)
                break
            case .failure(let localizedErrorMessage):
                showError(textField: textField, messagelabel: ageErrorLabel, message: localizedErrorMessage)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            ageTextField.becomeFirstResponder()
        } else {
            ageTextField.resignFirstResponder()
        }
        
        return true
    }
}

