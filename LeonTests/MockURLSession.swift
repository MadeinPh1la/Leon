//
//  MockURLSession.swift
//  LeonTests
//
//  Created by Kevin Downey on 2/4/24.
//

import XCTest
@testable import Leon


class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() {
        // Implementation for mock, can be empty or notify a closure when it's called
    }
}

class MockURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(nextData, nil, nextError)
        return nextDataTask
    }
}
