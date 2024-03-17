//
//  AuthViewModelTests.swift
//  LeonTests
//
//  Created by Kevin Downey on 3/13/24.
//

@testable import Leon
import XCTest


class AuthViewModelTests: XCTestCase {
    var viewModel: AuthViewModel!
    var mockAuth: MockAuth!

    override func setUp() {
        super.setUp()
        mockAuth = MockAuth()
        viewModel = AuthViewModel(authService: mockAuth)
    }

    override func tearDown() {
        viewModel = nil
        mockAuth = nil
        super.tearDown()
    }

    func testSignInSuccess() {
        mockAuth.shouldAuthenticateSuccessfully = true
        viewModel.signIn(email: "test@example.com", password: "password")
        
        XCTAssertTrue(viewModel.isAuthenticated)
    }

}


