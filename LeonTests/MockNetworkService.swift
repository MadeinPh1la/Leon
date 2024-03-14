//
//  MockNetworkService.swift
//  LeonTests
//
//  Created by Kevin Downey on 3/13/24.
//

import Combine
import Foundation
@testable import Leon  // Import your main app module

class MockNetworkService: NetworkService {
    var mockResponse: Data?
    var error: Error?
    
    func fetchData<T>(from url: URL, responseType: T.Type) -> AnyPublisher<T, Error> where T: Decodable {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return Just(mockResponse!)
            .tryMap { data -> T in
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
