//
//  Service.swift
//  MovieMosaic
//
//  Created by Harish Kshirsagar on 25/02/25.
//

import Foundation
import Combine

enum NetworkError: Error {
    case unknownError
    case invalidRequest
    case invalidResponse
    case decodingFailed
    case invalidURL
}

protocol ServiceProvider {
    func perform<T: Decodable>(from urlString: String) -> AnyPublisher<T, Error>
}
            
class Service: ServiceProvider {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func perform<T: Decodable>(from urlString: String) -> AnyPublisher<T, Error> {
        print(urlString)
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return self.session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}
