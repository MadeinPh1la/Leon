//
//  URLSessionProtocol.swift
//  Leon
//
//  Created by Kevin Downey on 3/3/24.
//

// URLSessionProtocols.swift

import Foundation
import Combine

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

protocol URLSessionProtocol {
    func fetchData<T: Decodable>(from url: URL, responseType: T.Type) -> AnyPublisher<T, Error>
}


extension URLSession: URLSessionProtocol {
    func fetchData<T: Decodable>(from url: URL, responseType: T.Type) -> AnyPublisher<T, Error> {
        self.dataTaskPublisher(for: url)
            .mapError { $0 as Error }  // Convert URLError to Error
            .flatMap { data, response -> AnyPublisher<T, Error> in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
                }
                return Just(data)
                    .decode(type: T.self, decoder: JSONDecoder())
                    .mapError { $0 as Error }  // Convert DecodingError to Error
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

