//
//  ContentView.swift
//  MovieMosaic
//
//  Created by Harish Kshirsagar on 25/02/25.
//

import SwiftUI

struct MovieListView: View {
    
    @State var searchText: String
    @StateObject var viewModel: MovieListViewModel = MovieListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter Movie Name", text: $searchText)
                    .frame(width: .infinity, height: 40)
                    .textFieldStyle(.plain)
                    .background(.gray.opacity(0.5))
                    .cornerRadius(20)
                    .onSubmit {
                        self.viewModel.fetchMovies(searchText: self.searchText.trimmingCharacters(in: .whitespaces))
                    }
                    .padding(20)
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                List(viewModel.movies, id: \.imdbID) { movie in
                    HStack {
                        AsyncImage(url: URL(string: movie.poster)) { phase in
                            NavigationLink(destination: MovieDetailView(imdbID: movie.imdbID)) {
                                switch phase {
                                case .empty:
                                    ProgressView() // Loading indicator
                                case .success(let image):
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                        .shadow(color: .black.opacity(0.2) ,radius: 2, x: 5, y: 5)
                                    
                                case .failure:
                                    Image(systemName: "photo") // Default system placeholder
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(movie.title)
                                        .font(.title2)
                                    Text(movie.year)
                                        .font(.callout)
                                }
                            }
                            
                          
                        }
                    }
                }
                .listStyle(.plain)
                Spacer()
            }
            .navigationTitle("Movies")
        }
    }
}

#Preview {
    MovieListView(searchText: "")
}
