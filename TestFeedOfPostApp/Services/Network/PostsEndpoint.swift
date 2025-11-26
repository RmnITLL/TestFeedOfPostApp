//
//  PostsEndpoint.swift
//  TestFeedOfPostApp
//

import Alamofire

enum PostsEndpoint {
    case fetchPosts
    case fetchPost(id: Int)
}

extension PostsEndpoint: Endpoint {
    var baseURL: String {
        return AppConstants.baseURL
    }

    var path: String {
        switch self {
        case .fetchPosts:
            return "/posts"
        case .fetchPost(let id):
            return "/posts/\(id)"
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var parameters: Parameters? {
        switch self {
        case .fetchPosts, .fetchPost:
            return nil  
        }
    }

    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }
}
