//
//  PostScreenView.swift
//  PlanetsApp
//
//  Created by rescalon on 18/5/24.
//

import SwiftUI

struct PostScreenView: View {
    @StateObject private var viewModel = PostViewModel()
    
    var body: some View {
        NavigationStack {
            postListContent
                .navigationTitle("Posts")
                .onAppear {
                    viewModel.getPostsWithCombine()
                }
        }
    }
    
    @ViewBuilder
    var postListContent : some View {
        if viewModel.isLoading {
            ProgressView()
        } else {
            if !viewModel.onPostsError.isEmpty {
                CustomUnavailableContentView(
                    image: "empty_planet",
                    title: "An error has occurred!",
                    description: viewModel.onPostsError) {
                        Button("Try Again") {
                            viewModel.getPostsWithCombine()
                        }
                        .buttonStyle(.borderedProminent)
                    }
            } else {
                List(viewModel.postList) { post in
                    NavigationLink {
                        PostDetailView(postId: post.id)
                    } label: {
                        makePostsCardItemView(post: post)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
    }
    
    private func makePostsCardItemView(post: Post) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(post.title.capitalized)
                    .font(.title2)
                    .lineLimit(2)
                    .bold()
                Spacer()
                Image("apod3")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            }
            Text(post.body.capitalized)
                .font(.body)
                .fontWeight(.light)
        }
    }
}

#Preview {
    NavigationStack {
        PostScreenView()
    }
}
