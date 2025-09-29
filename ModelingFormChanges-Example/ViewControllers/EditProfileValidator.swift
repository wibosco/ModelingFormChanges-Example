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
    let usernameLocalizedErrorMessage: String?
}

class EditProfileValidator: NSObject {
    
    private let user: User
    private var userNameChanged = false
    
    var username: String? {
        didSet {
            userNameChanged = (username != user.username)
        }
    }
    
    // MARK: - Init
    
    init(user: User) {
        self.user = user
        super.init()
        
        username = user.username
    }
    
    // MARK: - Change
    
    func hasMadeChanges() -> Bool {
        return userNameChanged
    }
    
    func changes() -> [String: Any] {
        var changes = [String: Any]()
        
        if userNameChanged {
            changes["username"] = username
        }
        
        return changes
    }
    
    // MARK: - Validators
    
    func validateAccountDetails() -> ValidationResult<EditProfileErrorMessages> {
        var errorMessage: String? = nil
        
        switch validateUsername() {
        case .success:
            break
        case .failure(let message):
            errorMessage = message
        }
        
        if errorMessage != nil {
            let editProfileErrorMessages = EditProfileErrorMessages(usernameLocalizedErrorMessage: errorMessage)
            
            return .failure(editProfileErrorMessages)
        }
        
        return .success
    }
    
    func validateUsername() -> ValidationResult<String> {
        guard let username else {
            return .failure("Username can not be empty")
        }
        
        if username.count < 2 {
            return .failure("Username is too short")
        } else {
            return .success
        }
    }
}
