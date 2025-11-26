//
//  Endpoint.swift
//  TestFeedOfPostApp
//

import Alamofire

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
}

    
extension Endpoint {
    var baseURL: String {
        return AppConstants.baseURL
    }

    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }
}
