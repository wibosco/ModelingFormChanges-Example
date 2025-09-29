//
//  EditProfileValidatorTests.swift
//  ModelingFormChanges-Example
//
//  Created by William Boles on 12/12/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest

class EditProfileValidatorTests: XCTestCase {
    
    var sut: EditProfileValidator!
    var user: User!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        user = User(username: "Samantha")
        sut = EditProfileValidator(user: user)
    }
    
    override func tearDown() {
    
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_firstName_valid() {
        sut.username = "Tommy"
        
        XCTAssertEqual(sut.validateUsername(), .success)
    }
    
    func test_firstName_invalidEmpty() {
        sut.username = ""
        
        XCTAssertEqual(sut.validateUsername(), .failure("Username is too short"))
    }
    
    func test_firstName_invalidNil() {
        sut.username = nil
        
        XCTAssertEqual(sut.validateUsername(), .failure("Username can not be empty"))
    }
    
    func test_hasMadeChanges_firstName() {
        sut.username = "Emma"
        
        XCTAssertTrue(sut.hasMadeChanges())
    }
    
    func test_changes_firstName() {
        let username = "Emma"
        sut.username = username
        
        let changes:[String: Any] = ["username": username]
        
        XCTAssertEqual(sut.changes() as NSDictionary, changes as NSDictionary)
    }
    
    func test_changes_noChanges() {
        let changes = [String: Any]()
        
        XCTAssertEqual(sut.changes() as NSDictionary, changes as NSDictionary)
    }
}
