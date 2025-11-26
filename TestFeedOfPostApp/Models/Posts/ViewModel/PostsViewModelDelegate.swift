//
//  PostsViewModelDelegate.swift
//  TestFeedOfPostApp
//
//  Created by R Kolos on 26/11/25.
//

import Foundation
import UIKit

protocol PostsViewModelDelegate: AnyObject {
    func postsDidUpdate()
    func postsDidFailWithError(_ error: String)
}

class PostsViewModel {
    private let networkService: NetworkServiceProtocol
    private let coreDataManager: CoreDataManager
    private var posts: [PostEntity] = []

    weak var delegate: PostsViewModelDelegate?

    var numberOfPosts: Int {
        return posts.count
    }

    init(networkService: NetworkServiceProtocol = NetworkService.shared as NetworkServiceProtocol,
         coreDataManager: CoreDataManager = .shared) {
        self.networkService = networkService
        self.coreDataManager = coreDataManager
    }

    func post(at index: Int) -> PostEntity? {
        guard index < posts.count else { return nil }
        return posts[index]
    }

    func loadPosts() {
        loadCachedPosts()
        fetchPostsFromAPI()
    }


    private func loadCachedPosts() {
        posts = coreDataManager.fetchPosts()
        delegate?.postsDidUpdate()
    }

    private func fetchPostsFromAPI(forceRefresh: Bool = false) {
        networkService.fetchPosts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    if forceRefresh {
                        self?.coreDataManager.deleteAllPosts()
                    }
                    self?.coreDataManager.savePosts(posts)
                    self?.posts = self?.coreDataManager.fetchPosts() ?? []
                    self?.delegate?.postsDidUpdate()
                case .failure(let error):
                    self?.delegate?.postsDidFailWithError("Failed to load posts: \(error.localizedDescription)")
                }
            }
        }
    }

    func refreshPosts() {
        networkService.fetchPosts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self?.coreDataManager.deleteAllPosts()
                    self?.coreDataManager.savePosts(posts)


                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self?.posts = self?.coreDataManager.fetchPosts() ?? []
                        self?.delegate?.postsDidUpdate()
                    }

                case .failure(let error):
                    self?.posts = self?.coreDataManager.fetchPosts() ?? []
                    self?.delegate?.postsDidUpdate()
                    self?.delegate?.postsDidFailWithError("Failed to refresh posts: \(error.localizedDescription)")
                }
            }
        }
    }

}
