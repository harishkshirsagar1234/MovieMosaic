//
//  Utility.swift
//  MovieMosaic
//
//  Created by Harish Kshirsagar on 27/02/25.
//

struct Endpoints {
    static let apiKey = "5c248545"

    static func searchText(_ text : String) -> String {
        "https://www.omdbapi.com/?s=\(text)&page=1&apikey=\(apiKey)"
    }
    
    static func urlForMovieDetail(by imdbID: String) -> String {
        guard !imdbID.isEmpty else { return "" }
        return "https://www.omdbapi.com/?i=\(imdbID)&apikey=\(apiKey)"
    }
}
