//
//  PostDetailView.swift
//  PlanetsApp
//
//  Created by rescalon on 18/5/24.
//

import SwiftUI

struct PostDetailView: View {
    @StateObject private var viewModel = PostViewModel()
    let postId : Int
    
    var body: some View {
        VStack {
            postDetails
                .navigationTitle("Post")
                .onAppear {
                    viewModel.getPostWithCombine(postId: postId)
                }
        }
    }
    
    @ViewBuilder
    var postDetails : some View {
        if viewModel.isLoading {
            ProgressView()
        } else {
            if !viewModel.onPostsError.isEmpty {
                CustomUnavailableContentView(
                    image: "empty_planet",
                    title: "An error has occurred!",
                    description: viewModel.onPostsError) {
                        Button("Try Again") {
                            viewModel.getPostWithCombine(postId: postId)
                        }
                        .buttonStyle(.borderedProminent)
                    }
            } else {
                VStack(alignment: .leading) {
                    Text(viewModel.post.title.capitalized)
                        .font(.title)
                    Divider()
                    Text(viewModel.post.body.capitalized)
                        .font(.body)
                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    NavigationStack {
        PostDetailView(postId: 1)
    }
}
