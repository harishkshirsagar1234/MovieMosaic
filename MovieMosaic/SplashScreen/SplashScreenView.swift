//
//  SplashScreenView.swift
//  MovieMosaic
//
//  Created by Harish Kshirsagar on 28/02/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive: Bool = false
    @State private var scale: CGFloat = 0.5
    var body: some View {
        if isActive {
            MovieListView(searchText: "") // Navigate to main view
        } else {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.black.opacity(0.5)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                VStack {
                    Image(systemName: "movieclapper.fill") // Replace with your app logo
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .scaleEffect(scale)
                        .onAppear {
                            withAnimation(.spring(response: 1, dampingFraction: 0.5, blendDuration: 1)) {
                                scale = 1.0
                            }
                        }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
