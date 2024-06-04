//
//  PostViewModel.swift
//  PlanetsApp
//
//  Created by rescalon on 18/5/24.
//

import Foundation

class PostViewModel : ObservableObject {
    private var networkService: NetworkService = NetworkService()
    @Published private(set) var postList : [Post] = []
    @Published private(set) var post : Post = Post.default
    @Published private(set) var onPostsError : String = ""
    @Published private(set) var isLoading = false
    
    /**
     Getting all posts from the API
     */
    func getPosts() {
        isLoading = true
        let postParam = "posts"
        networkService.getListData(
            urlParam: postParam,
            onSuccess: { (posts: [Post]?) in
                print("POST in PostScreenView: \(String(describing: posts))")
                DispatchQueue.main.async { [weak self] in
                    guard let posts = posts else { return }
                    self?.postList = posts
                    self?.isLoading = false
                }
            },
            onFailure: { error in
                DispatchQueue.main.async { [weak self] in
                    self?.handleError(error: error)
                }
            }
        )
    }
    
    /**
     Getting a Single post from the API.
     */
    func getPost(postId: Int) {
        isLoading = true
        networkService.getData(urlParam: "posts/" + String(postId)) { (post: Post?) in
            DispatchQueue.main.async { [weak self] in
                guard let post = post else { return }
                self?.post = post
                self?.isLoading = false
            }
        } onFailure: { error in
            DispatchQueue.main.async { [weak self] in
                self?.handleError(error: error)
            }
        }
    }
    
    func getPostsWithCombine() {
        isLoading = true
        networkService.getListDataWithCombine(urlParam: "posts") { [weak self] (posts: [Post]?) in
            guard let posts = posts else { return }
            self?.postList = posts
            self?.isLoading = false
        } onFailure: { [weak self] error in
            self?.handleError(error: error)
        }

    }
    
    func getPostWithCombine(postId: Int) {
        isLoading = true
        networkService.getDataWithCombine(urlParam: "posts/" + String(postId)) { [weak self] (post: Post?) in
            guard let post = post else { return }
            self?.post = post
            self?.isLoading = false
        } onFailure: { [weak self] error in
            self?.handleError(error: error)
        }
    }
    
    private func handleError(error: String) {
        self.onPostsError = error
        self.isLoading = false
    }
}
