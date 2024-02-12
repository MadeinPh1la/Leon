//
//  AuthViewModelTests.swift
//  LeonTests
//
//  Created by Kevin Downey on 2/12/24.
//

@testable import Leon
import XCTest
import FirebaseAuth

class AuthViewModelTests: XCTestCase {
    var viewModel: AuthViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        viewModel = AuthViewModel()
        // Setup any required mock services or initial state
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }
    
    func testSignUpSuccess() {
        let expectation = self.expectation(description: "SignUpSuccess")
        
        viewModel.signUp(email: "test@example.com", password: "password123") { success, error in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // Test for Sign-Up Failure
    func testSignUpFailure() {
        let expectation = self.expectation(description: "SignUpFailure")
        
        // Assuming 'viewModel' is already setup to use a mock or actual service
        // This email and password should be adjusted to trigger a failure in sign-up
        viewModel.signUp(email: "invalid@example.com", password: "123") { success, error in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // Test for Successful Sign-In
    func testSignInSuccess() {
        let expectation = self.expectation(description: "SignInSuccess")

        viewModel.signIn(email: "valid@example.com", password: "correctPassword") { success, error in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}
