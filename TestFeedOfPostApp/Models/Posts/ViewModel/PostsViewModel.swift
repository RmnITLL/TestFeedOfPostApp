//
//  PostsViewModel.swift
//  TestFeedOfPostApp
//
//  Created by R Kolos on 27/11/25.
//

import UIKit

class PostsViewModel {
    private let networkService: NetworkServiceProtocol
    private let coreDataManager: CoreDataManager
    private var posts: [PostEntity] = []
    private var currentPage = 1
    private var isLoading = false
    private var canLoadMore = true
    private var hasShownEndOfPostsAlert = false

    weak var delegate: PostsViewModelDelegate?

    var numberOfPosts: Int {
        return posts.count
    }

    init(networkService: NetworkServiceProtocol = NetworkService.shared,
         coreDataManager: CoreDataManager = .shared) {
        self.networkService = networkService
        self.coreDataManager = coreDataManager
    }

    func post(at index: Int) -> PostEntity? {
        guard index < posts.count else { return nil }
        return posts[index]
    }

    func loadPosts() {
        let cachedPosts = coreDataManager.fetchPosts()
        if !cachedPosts.isEmpty {
            self.posts = cachedPosts
            self.delegate?.postsDidUpdate()
        }

        fetchFirstPage()
    }

    func loadNextPage() {
        guard !isLoading && canLoadMore else { return }

        isLoading = true

        networkService.fetchPosts(page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false

                switch result {
                case .success(let newPosts):
                    if newPosts.isEmpty {

                        self?.canLoadMore = false
                        if !(self?.hasShownEndOfPostsAlert ?? true) {
                            self?.hasShownEndOfPostsAlert = true
                            self?.delegate?.didReachEndOfPosts()
                        }
                    } else {
                        self?.currentPage += 1
                        self?.coreDataManager.savePosts(newPosts)
                        self?.posts = self?.coreDataManager.fetchPosts() ?? []
                        self?.delegate?.postsDidUpdate()
                    }
                case .failure(let error):
                    print("Failed to load more posts: \(error.localizedDescription)")
                }
            }
        }
    }

    func refreshPosts() {
        guard !isLoading else { return }

        isLoading = true
        currentPage = 1
        canLoadMore = true
        hasShownEndOfPostsAlert = false

        posts.removeAll()
        delegate?.postsDidUpdate()

        networkService.fetchPosts(page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false

                switch result {
                case .success(let posts):
                    self?.coreDataManager.deleteAllPosts()
                    self?.coreDataManager.savePosts(posts)
                    self?.posts = self?.coreDataManager.fetchPosts() ?? []
                    self?.delegate?.postsDidUpdate()

                    if posts.isEmpty && !(self?.hasShownEndOfPostsAlert ?? true) {
                        self?.hasShownEndOfPostsAlert = true
                        self?.delegate?.didReachEndOfPosts()
                    }

                case .failure(let error):
                    self?.posts = self?.coreDataManager.fetchPosts() ?? []
                    self?.delegate?.postsDidUpdate()

                    if self?.posts.isEmpty == true {
                        self?.delegate?.postsDidFailWithError("Failed to refresh posts: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    private func fetchFirstPage() {
        isLoading = true

        networkService.fetchPosts(page: 1) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.currentPage = 1

                switch result {
                case .success(let posts):
                    self?.coreDataManager.deleteAllPosts()
                    self?.coreDataManager.savePosts(posts)
                    self?.posts = self?.coreDataManager.fetchPosts() ?? []
                    self?.delegate?.postsDidUpdate()

                    if posts.isEmpty && !(self?.hasShownEndOfPostsAlert ?? true) {
                        self?.hasShownEndOfPostsAlert = true
                        self?.delegate?.didReachEndOfPosts()
                    }

                case .failure(let error):
                    if self?.posts.isEmpty == true {
                        self?.delegate?.postsDidFailWithError("Failed to load posts: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

