//
//  NetworkServiceProtocol.swift
//  TestFeedOfPostApp
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchPosts(page: Int, completion: @escaping (Result<[Post], Error>) -> Void)
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void)
}
