//
//  MovieListViewModelTests.swift
//  MovieMosaicTests
//
//  Created by Harish Kshirsagar on 01/01/26.
//
import XCTest
@testable import MovieMosaic
import Combine


class MovieListViewModelTests: XCTestCase {

   let unitUnderTest = MovieListViewModel(movieCoordinator: MovieCoordinator(service: MockService()))
    let mockCoordinator = MovieCoordinator(service: MockService())
   var cancellable = Set<AnyCancellable>()
    
    func testFetchMovies() {
        let expectation = XCTestExpectation(description: "Wait for api response")
        unitUnderTest.$movies
            .dropFirst()
            .sink { movies in
                XCTAssertEqual(movies.count, 10)
                XCTAssertNil(self.unitUnderTest.errorMessage)
                expectation.fulfill()
            }
            .store(in: &cancellable)

        unitUnderTest.fetchMovies(searchText: "test")
        
        wait(for: [expectation], timeout: 3)

    }

}

class MockService: ServiceProvider {
    
    func perform<T: Decodable>(from urlString: String) -> AnyPublisher<T, Error> {
        // 1. Get JSON from bundle for testing
        guard let url = Bundle.main.url(forResource: "Movies", withExtension: "json") else {
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


