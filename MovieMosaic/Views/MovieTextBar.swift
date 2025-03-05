//
//  MovieTextBar.swift
//  MovieMosaic
//
//  Created by Harish Kshirsagar on 26/02/25.
//

import SwiftUI

struct MovieTextBar: View {
    @Binding var searchText: String
    var body: some View {
            VStack {
                TextField("Enter Movie Name", text: $searchText)
                    .frame(width: .infinity, height: 40)
                    .textFieldStyle(.plain)
                    .background(.gray.opacity(0.5))
                    .cornerRadius(20)
                    .onSubmit {
                        print("Submitted text: \(searchText)")
                    }
              }
        .padding(20)
    }
}

#Preview {
    MovieTextBar(searchText: .constant(""))
}
