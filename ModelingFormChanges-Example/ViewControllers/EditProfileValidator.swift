//
//  EditProfileValidator.swift
//  ModelingFormChanges-Example
//
//  Created by William Boles on 11/12/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

enum ValidationResult<E: Equatable>: Equatable {
    case success
    case failure(E)
}

func ==<E: Equatable>(lhs: ValidationResult<E>, rhs: ValidationResult<E>) -> Bool {
    switch (lhs, rhs) {
    case (let .failure(failureLeft), let .failure(failureRight)):
        return failureLeft == failureRight
    case (.success, .success):
        return true
    default:
        return false
    }
}

struct EditProfileErrorMessages: Equatable {
    let firstNameLocalizedErrorMessage: String?
    let lastNameLocalizedErrorMessage: String?
    let emailLocalizedErrorMessage: String?
    let ageLocalizedErrorMessage: String?
}

func ==(lhs: EditProfileErrorMessages, rhs: EditProfileErrorMessages) -> Bool {
    return lhs.emailLocalizedErrorMessage == rhs.emailLocalizedErrorMessage &&
        lhs.lastNameLocalizedErrorMessage == rhs.lastNameLocalizedErrorMessage &&
        lhs.emailLocalizedErrorMessage == rhs.emailLocalizedErrorMessage &&
        lhs.ageLocalizedErrorMessage == rhs.ageLocalizedErrorMessage
}

class EditProfileValidator: NSObject {
    
    private let user: User
    private var firstNameChanged = false
    private var lastNameChanged = false
    private var emailChanged = false
    private var ageChanged = false
    
    var firstName: String? {
        didSet {
            firstNameChanged = (firstName != user.firstName)
        }
    }
    
    var lastName: String? {
        didSet {
           lastNameChanged = (lastName != user.lastName)
        }
    }

    var email: String? {
        didSet {
           emailChanged = (email != user.email)
        }
    }

    var age: Int? {
        didSet {
            ageChanged = (age != user.age)
        }
    }
    
    // MARK: - Init
    
    init(user: User) {
        self.user = user
        super.init()
        
        firstName = user.firstName
        lastName = user.lastName
        email = user.email
        age = user.age
    }
    
    // MARK: - Change
    
    func hasMadeChanges() -> Bool {
        return firstNameChanged || lastNameChanged || emailChanged || ageChanged
    }
    
    func changes() -> [String: Any] {
        var changes = [String: Any]()
        
        if firstNameChanged {
            changes["firstname"] = firstName
        }
        
        if lastNameChanged {
            changes["lastname"] = lastName
        }
        
        if emailChanged {
            changes["email"] = email
        }
        
        if ageChanged {
            changes["age"] = age
        }
        
        return changes
    }
    
    // MARK: - Validators
    
    func validateAccountDetails() -> ValidationResult<EditProfileErrorMessages> {
        var firstNameError: String? = nil
        var lastNameError: String? = nil
        var emailError: String? = nil
        var ageError: String? = nil
        
        switch validateFirstName() {
        case .success:
            break
        case .failure(let message):
            firstNameError = message
        }
        
        switch validateLastName() {
        case .success:
            break
        case .failure(let message):
            lastNameError = message
        }
        
        switch validateEmail() {
        case .success:
            break
        case .failure(let message):
            emailError = message
        }
        
        switch validateAge() {
        case .success:
            break
        case .failure(let message):
            ageError = message
        }
        
        if firstNameError != nil || lastNameError != nil || emailError != nil || ageError != nil {
            let editProfileErrorMessages = EditProfileErrorMessages(firstNameLocalizedErrorMessage: firstNameError, lastNameLocalizedErrorMessage: lastNameError, emailLocalizedErrorMessage: emailError, ageLocalizedErrorMessage: ageError)
            
            return .failure(editProfileErrorMessages)
        }
        
        return .success
    }
    
    func validateFirstName() -> ValidationResult<String> {
        guard let firstName = firstName else {
            return .failure("Firstname can not be empty")
        }
        
        if firstName.count < 2 {
            return .failure("Firstname is too short")
        } else {
            return .success
        }
    }
    
    func validateLastName() -> ValidationResult<String> {
        guard let lastName = lastName else {
            return .failure("Lastname can not be empty")
        }
        
        if lastName.count < 2 {
            return .failure("Lastname is too short")
        } else {
            return .success
        }
    }
    
    func validateEmail() -> ValidationResult<String> {
        guard let email = email else {
            return .failure("Email can not be empty")
        }
        
        if email.count < 5 {
            return .failure("Email is too short")
        } else {
            return .success
        }
    }
    
    func validateAge() -> ValidationResult<String> {
        guard let age = age else {
            return .failure("Age can not be empty")
        }
        
        let minimumAge = 13
        let maximumAge = 124
        
        if age < minimumAge || age > maximumAge {
            return .failure("Must be older than \(minimumAge) and younger than \(maximumAge)")
        } else {
            return .success
        }
    }
}
