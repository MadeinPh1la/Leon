//
//  NetworkService.swift
//  Leon
//
//  Created by Kevin Downey on 3/13/24.
//

import Foundation
import Combine

protocol NetworkService {
    func fetchData<T: Decodable>(from url: URL, responseType: T.Type) -> AnyPublisher<T, Error>
}

extension URLSession: NetworkService {
    func fetchData<T: Decodable>(from url: URL) -> AnyPublisher<T, Error> {
        self.dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .flatMap { pair in
                Just(pair.data)
                    .decode(type: T.self, decoder: JSONDecoder())
                    .mapError { $0 as Error }
            }
            .eraseToAnyPublisher()
    }
}
