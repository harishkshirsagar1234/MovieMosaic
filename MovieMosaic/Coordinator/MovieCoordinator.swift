//
//  MovieCoordinator.swift
//  MovieMosaic
//
//  Created by Harish Kshirsagar on 26/02/25.
//

import Foundation
import Combine

protocol MovieCoordinatorProving {
    func fetchMovies(endpoint: String) -> AnyPublisher<MovieResponse, Error>
    func fetchMovieDetails(endpoint: String) -> AnyPublisher<MovieDetailResponse, Error>
}

class MovieCoordinator: MovieCoordinatorProving {
    
    var service: Service
    
    init(service: Service) {
        self.service = service
    }
    
    func fetchMovies(endpoint: String) -> AnyPublisher<MovieResponse, Error> {
        return self.service.perform(from: endpoint)
    }
    
    func fetchMovieDetails(endpoint: String) -> AnyPublisher<MovieDetailResponse, Error> {
        return self.service.perform(from: endpoint)
    }
}
