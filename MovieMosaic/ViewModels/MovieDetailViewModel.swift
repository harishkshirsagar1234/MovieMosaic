//
//  MovieDetailViewModel.swift
//  MovieMosaic
//
//  Created by Harish Kshirsagar on 28/02/25.
//
import SwiftUI
import Combine

class MovieDetailViewModel: ObservableObject {
    
    let movieCoordinator: MovieCoordinator
    @Published var movieDetail: MovieDetail? = nil
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    var rowDetails = [RowDetails]()
    
    init(movieDetail: MovieDetail? = nil,
         movieCoordinator: MovieCoordinator = MovieCoordinator(service: Service())) {
        self.movieDetail = movieDetail
        self.movieCoordinator = movieCoordinator
    }
    
    func fetchMovieDetails(imdbID: String) {
        self.isLoading = true
        self.errorMessage = nil
        let endpoint = Endpoints.urlForMovieDetail(by: imdbID)
        self.movieCoordinator.fetchMovieDetails(endpoint: endpoint)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
        } receiveValue: { [weak self] movieDetailResponse in
            self?.movieDetail = MovieDetail(movieDetailResponse: movieDetailResponse)
            self?.appendMovieDetails()
        }
        .store(in: &cancellables)

    }
    
    func appendMovieDetails() {
        guard let movieDetail = self.movieDetail else {
            return
        }
        self.rowDetails.append(RowDetails(key: "Title", value: movieDetail.title))
        self.rowDetails.append(RowDetails(key: "Actor", value: movieDetail.actors))
        self.rowDetails.append(RowDetails(key: "Awards", value: movieDetail.awards))
        self.rowDetails.append(RowDetails(key: "Country", value: movieDetail.country))
        self.rowDetails.append(RowDetails(key: "Director", value: movieDetail.director))
        self.rowDetails.append(RowDetails(key: "Language", value: movieDetail.language))
        self.rowDetails.append(RowDetails(key: "BoxOffice", value: movieDetail.boxOffice))
        self.rowDetails.append(RowDetails(key: "Released on", value: movieDetail.released))
        self.rowDetails.append(RowDetails(key: "Year", value: movieDetail.year))
        self.rowDetails.append(RowDetails(key: "Writer", value: movieDetail.writer))
        self.rowDetails.append(RowDetails(key: "Ratings", value: movieDetail.ratings))
    }
}


struct MovieDetail {
    
    let movieDetailResponse: MovieDetailResponse
    
    init(movieDetailResponse: MovieDetailResponse) {
        self.movieDetailResponse = movieDetailResponse
    }
    
    var title: String {
        movieDetailResponse.title
    }
    
    var actors: String {
        movieDetailResponse.actors
    }
    
    var awards: String {
        movieDetailResponse.awards
    }
    
    var country: String {
        movieDetailResponse.country
    }
    
    var director: String {
        movieDetailResponse.director
    }
    
    var imdbRating: String {
        movieDetailResponse.imdbRating
    }
    
    var imdbVotes: String {
        movieDetailResponse.imdbVotes
    }
    
    var language: String {
        movieDetailResponse.language
    }
    
    var released: String {
        movieDetailResponse.released
    }
    
    var writer: String {
        movieDetailResponse.writer
    }
    
    var boxOffice: String {
        movieDetailResponse.boxOffice
    }
    
    var ratings: String {
        movieDetailResponse.ratings[0].value
    }
    
    var poster: String {
        movieDetailResponse.poster
    }
    
    var year: String {
        movieDetailResponse.year
    }
}


struct RowDetails: Identifiable {
    let id = UUID()
    let key: String
    let value: String
}
