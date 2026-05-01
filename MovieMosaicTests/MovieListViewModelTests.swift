//
//  MovieListViewModelTests.swift
//  MovieMosaicTests
//
//  Created by Harish Kshirsagar on 01/01/26.
//
import XCTest
@testable import YourAppModuleName
import Combine


class MovieListViewModelTests {

   let unitUnderTest = MovieListViewModel(movieCoordinator: MovieCoordinator(service: MockService()))
    
    func testFetchMovies() {
        unitUnderTest.fetchMovies(searchText: "test")
        XCTAssertEqual(unitUnderTest.movies.count, 10)
    }

}

class MockService: ServiceProvider {
    
    func perform<T: Decodable>(from urlString: String) -> AnyPublisher<T, Error> {
        // 1. Get JSON from bundle for testing
        guard let url = Bundle.main.url(forResource: urlString, withExtension: "json") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        // 2. Load data and decode
        return Future<Data, Error> { promise in
            do {
                let data = try Data(contentsOf: url)
                promise(.success(data))
            } catch {
                promise(.failure(error))
            }
        }
        .receive(on: DispatchQueue.main)
        .decode(type: T.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
    
    
}


