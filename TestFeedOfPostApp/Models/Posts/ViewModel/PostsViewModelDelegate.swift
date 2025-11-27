//
//  PostsViewModelDelegate.swift
//  TestFeedOfPostApp
//

import Foundation

protocol PostsViewModelDelegate: AnyObject {
    func postsDidUpdate()
    func postsDidFailWithError(_ error: String)
    func didReachEndOfPosts()
}

