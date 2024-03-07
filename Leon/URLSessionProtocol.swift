//
//  URLSessionProtocol.swift
//  Leon
//
//  Created by Kevin Downey on 3/3/24.
//

// URLSessionProtocols.swift

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

// Extending URLSessionDataTask to conform to URLSessionDataTaskProtocol
extension URLSessionDataTask: URLSessionDataTaskProtocol {}

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let task: URLSessionDataTask = self.dataTask(with: url, completionHandler: completionHandler)
        return task as URLSessionDataTaskProtocol
    }
}
