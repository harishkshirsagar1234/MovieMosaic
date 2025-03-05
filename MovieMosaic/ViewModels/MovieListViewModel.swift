//
//  MovieListViewModel.swift
//  MovieMosaic
//
//  Created by Harish Kshirsagar on 27/02/25.
//

import SwiftUI
import Combine

class MovieListViewModel: ObservableObject {
    
    let movieCoordinator: MovieCoordinator
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    
    init(movieCoordinator: MovieCoordinator = MovieCoordinator(service: Service())) {
        self.movieCoordinator = movieCoordinator
    }
    
    func fetchMovies(searchText: String) {
        self.isLoading = true
        self.errorMessage = nil
        let endpoint = Endpoints.searchText(searchText)
        self.movieCoordinator.fetchMovies(endpoint: endpoint)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies.movies
            }
            .store(in: &cancellables)
    }
}
