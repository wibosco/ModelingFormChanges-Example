//
//  EditProfileValidatorTests.swift
//  ModelingFormChanges-Example
//
//  Created by William Boles on 12/12/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest

class EditProfileValidatorTests: XCTestCase {
    
    var validator: EditProfileValidator!
    var user: User!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        user = User(firstName: "Samantha", lastName: "MacDonald", email: "samantha.macdonald@test.com", age: 30)
        validator = EditProfileValidator(user: user)
    }
    
    override func tearDown() {
    
        super.tearDown()
    }
    
    // MARK: - Validation
    
    // MARK: FirstName
    
    func test_firstName_valid() {
        validator.firstName = "Tommy"
        
        XCTAssertEqual(validator.validateFirstName(), .success)
    }
    
    func test_firstName_invalidEmpty() {
        validator.firstName = ""
        
        XCTAssertEqual(validator.validateFirstName(), .failure("Firstname is too short"))
    }
    
    func test_firstName_invalidNil() {
        validator.firstName = nil
        
        XCTAssertEqual(validator.validateFirstName(), .failure("Firstname can not be empty"))
    }
    
    // MARK: LastName
    
    func test_lastName_valid() {
        validator.lastName = "Irvine"
        
        XCTAssertEqual(validator.validateLastName(), .success)
    }
    
    func test_lastName_invalidEmpty() {
        validator.lastName = ""
        
        XCTAssertEqual(validator.validateLastName(), .failure("Lastname is too short"))
    }
    
    func test_lastName_invalidNil() {
        validator.lastName = nil
        
        XCTAssertEqual(validator.validateLastName(), .failure("Lastname can not be empty"))
    }
    
    // MARK: Email
    
    func test_email_valid() {
        validator.email = "valid@test.com"
        
        XCTAssertEqual(validator.validateEmail(), .success)
    }
    
    func test_email_invalidEmpty() {
        validator.email = ""
        
        XCTAssertEqual(validator.validateEmail(), .failure("Email is too short"))
    }
    
    func test_email_invalidNil() {
        validator.email = nil
        
        XCTAssertEqual(validator.validateEmail(), .failure("Email can not be empty"))
    }
    
    // MARK: Age
    
    func test_age_valid() {
        validator.age = 45
        
        XCTAssertEqual(validator.validateAge(), .success)
    }
    
    func test_age_invalidTooYoung() {
        validator.age = 7
        
        XCTAssertEqual(validator.validateAge(), .failure("Must be older than 13 and younger than 124"))
    }
    
    func test_age_invalidTooOld() {
        validator.age = 145
        
        XCTAssertEqual(validator.validateAge(), .failure("Must be older than 13 and younger than 124"))
    }
    
    func test_age_invalidNil() {
        validator.age = nil
        
        XCTAssertEqual(validator.validateAge(), .failure("Age can not be empty"))
    }
    
    // MARK: AccountDetails
    
    func test_accountDetails_valid() {
        validator.firstName = "Graham"
        validator.lastName = "Jones"
        validator.email = "graham.jones@test.com"
        validator.age = 27
        
        XCTAssertEqual(validator.validateAccountDetails(), .success)
    }
    
    func test_accountDetails_invalidFirstName() {
        validator.firstName = nil
        validator.lastName = "Jones"
        validator.email = "graham.jones@test.com"
        validator.age = 27
        
        let editProfileErrorMessages = EditProfileErrorMessages(firstNameLocalizedErrorMessage: "Firstname can not be empty", lastNameLocalizedErrorMessage: nil, emailLocalizedErrorMessage: nil, ageLocalizedErrorMessage: nil)
        
        XCTAssertEqual(validator.validateAccountDetails(), .failure(editProfileErrorMessages))
    }
    
    func test_accountDetails_invalidLastName() {
        validator.firstName = "Graham"
        validator.lastName = nil
        validator.email = "graham.jones@test.com"
        validator.age = 27
        
        let editProfileErrorMessages = EditProfileErrorMessages(firstNameLocalizedErrorMessage: nil, lastNameLocalizedErrorMessage: "Lastname can not be empty", emailLocalizedErrorMessage: nil, ageLocalizedErrorMessage: nil)
        
        XCTAssertEqual(validator.validateAccountDetails(), .failure(editProfileErrorMessages))
    }
    
    func test_accountDetails_invalidEmail() {
        validator.firstName = "Graham"
        validator.lastName = "Jones"
        validator.email = nil
        validator.age = 27
        
        let editProfileErrorMessages = EditProfileErrorMessages(firstNameLocalizedErrorMessage: nil, lastNameLocalizedErrorMessage: nil, emailLocalizedErrorMessage: "Email can not be empty", ageLocalizedErrorMessage: nil)
        
        XCTAssertEqual(validator.validateAccountDetails(), .failure(editProfileErrorMessages))
    }
    
    func test_accountDetails_invalidAge() {
        validator.firstName = "Graham"
        validator.lastName = "Jones"
        validator.email = "graham.jones@test.com"
        validator.age = nil
        
        let editProfileErrorMessages = EditProfileErrorMessages(firstNameLocalizedErrorMessage: nil, lastNameLocalizedErrorMessage: nil, emailLocalizedErrorMessage: nil, ageLocalizedErrorMessage: "Age can not be empty")
        
        XCTAssertEqual(validator.validateAccountDetails(), .failure(editProfileErrorMessages))
    }
    
    func test_accountDetails_invalidMultiple() {
        validator.firstName = nil
        validator.lastName = nil
        validator.email = nil
        validator.age = nil
        
        let editProfileErrorMessages = EditProfileErrorMessages(firstNameLocalizedErrorMessage: "Firstname can not be empty", lastNameLocalizedErrorMessage: "Lastname can not be empty", emailLocalizedErrorMessage: "Email can not be empty", ageLocalizedErrorMessage: "Age can not be empty")
        
        XCTAssertEqual(validator.validateAccountDetails(), .failure(editProfileErrorMessages))
    }
    
    // MARK: - Changes
    
    // MARK: HasMadeChanges
    
    func test_hasMadeChanges_firstName() {
        validator.firstName = "Emma"
        
        XCTAssertTrue(validator.hasMadeChanges())
    }
    
    func test_hasMadeChanges_lastName() {
        validator.lastName = "Young"
        
        XCTAssertTrue(validator.hasMadeChanges())
    }
    
    func test_hasMadeChanges_email() {
        validator.email = "emma.young@test.com"
        
        XCTAssertTrue(validator.hasMadeChanges())
    }
    
    func test_hasMadeChanges_age() {
        validator.age = 78
        
        XCTAssertTrue(validator.hasMadeChanges())
    }
    
    func test_hasMadeChanges_noChanges() {
        XCTAssertFalse(validator.hasMadeChanges())
    }
    
    // MARK: ChangeDictionary
    
    func test_changes_firstName() {
        let firstName = "Emma"
        validator.firstName = firstName
        
        let changes:[String: Any] = ["firstname": firstName]
        
        XCTAssertEqual(validator.changes() as NSDictionary, changes as NSDictionary)
    }
    
    func test_changes_lastName() {
        let lastName = "Young"
        validator.lastName = lastName
        
        let changes:[String: Any] = ["lastname": lastName]
        
        XCTAssertEqual(validator.changes() as NSDictionary, changes as NSDictionary)
    }
    
    func test_changes_email() {
        let email = "emma.young@test.com"
        validator.email = email
        
        let changes:[String: Any] = ["email": email]
        
        XCTAssertEqual(validator.changes() as NSDictionary, changes as NSDictionary)
    }
    
    func test_changes_age() {
        let age = 56
        validator.age = age
        
        let changes:[String: Any] = ["age": age]
        
        XCTAssertEqual(validator.changes() as NSDictionary, changes as NSDictionary)
    }
    
    func test_changes_multiple() {
        let firstName = "Emma"
        let lastName = "Young"
        let email = "emma.young@test.com"
        let age = 56
        validator.firstName = firstName
        validator.lastName = lastName
        validator.email = email
        validator.age = age
        
        let changes:[String: Any] = ["firstname": firstName, "lastname": lastName, "email": email, "age": age]
        
        XCTAssertEqual(validator.changes() as NSDictionary, changes as NSDictionary)
    }
    
    func test_changes_noChanges() {
        let changes = [String: Any]()
        
        XCTAssertEqual(validator.changes() as NSDictionary, changes as NSDictionary)
    }
}
