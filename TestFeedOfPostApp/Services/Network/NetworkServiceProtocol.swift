//
//  NetworkServiceProtocol.swift
//  TestFeedOfPostApp
//


import Alamofire
import Foundation

protocol NetworkServiceProtocol {
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void)
    func fetchPost(id: Int, completion: @escaping (Result<Post, Error>) -> Void)
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private let session: Session

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        session = Session(configuration: configuration)
    }


    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        let url = endpoint.baseURL + endpoint.path

        session.request(url,
                        method: endpoint.method,
                        parameters: endpoint.parameters,
                        headers: endpoint.headers)
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        let endpoint = PostsEndpoint.fetchPosts
        request(endpoint, completion: completion)
    }

    func fetchPost(id: Int, completion: @escaping (Result<Post, Error>) -> Void) {
        let endpoint = PostsEndpoint.fetchPost(id: id)
        request(endpoint, completion: completion)
    }
}
