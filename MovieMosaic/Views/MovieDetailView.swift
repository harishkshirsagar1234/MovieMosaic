//
//  MovieDetailView.swift
//  MovieMosaic
//
//  Created by Harish Kshirsagar on 28/02/25.
//

import SwiftUI

struct MovieDetailView: View {

    @StateObject private var viewModel: MovieDetailViewModel = MovieDetailViewModel()
    @State var imdbID: String
    
    var body: some View {
        
        if viewModel.isLoading {
            ProgressView("Loading...")
        } else if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
                .foregroundColor(.red)
                .padding()
        }
        
        VStack {
            if let movieDetail = self.viewModel.movieDetail {
                AsyncImage(url: URL(string: movieDetail.poster)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView() // Loading indicator
                    case .success(let image):
                        image.resizable()
                            .frame(width: UIScreen.main.bounds.width, height: 300)
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
                    Text(movieDetail.title)
                        .font(.title)
                        .bold()
                }
                
                List(self.viewModel.rowDetails, id: \.id) { item in
                    TextView(title: item.key, value: item.value)
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            guard !self.imdbID.isEmpty else {
                return
            }
            viewModel.fetchMovieDetails(imdbID: self.imdbID)
        }
    }
}

#Preview {
    MovieDetailView(imdbID: "tt0372784")
}

struct TextView: View{
    @State var title: String
    @State var value: String
    var body: some View {
            HStack {
                Text("\(title):")
                    .font(.title2)
                    .padding(.horizontal, 20)
                    .bold()
                Spacer()
                Text(value)
                    .font(.title3)
                    .multilineTextAlignment(.trailing)
        }
    }
}
