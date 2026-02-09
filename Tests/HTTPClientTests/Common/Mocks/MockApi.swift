//
//  MockApi.swift
//  iOS-Generic-Datasource_Example
//
//  Created by raulbot on 22/3/23.
//

import Foundation
@testable import HTTPClient

enum MockApi: Api {
    static let fakeBaseUrl = "www.fake.com/"
    static let fakeEndpoint = "fake/endpoint"
    
    case getRequest
    case postWithBodyParams([String])
    case wrongURL
    case withCache
    case withHeaderParams(Int, Int, String)
    
    var method: HTTPMethod {
        switch self {
        case .getRequest, .wrongURL, .withCache, .withHeaderParams:
            return .get
        case .postWithBodyParams:
            return .post
        }
    }
    
    var url: String {
        switch self {
        case .getRequest, .postWithBodyParams, .withCache, .withHeaderParams:
            return MockApi.fakeBaseUrl + MockApi.fakeEndpoint
        case .wrongURL:
            return ""
        }
    }
    
    var headerParams: [String : Any] {
        switch self {
        case .getRequest, .postWithBodyParams, .wrongURL, .withCache:
            return [:]
        case .withHeaderParams(let start, let count, let sort):
            return ["Start": start, "Count": count, "Sort": sort]
        }
    }
    
    var bodyParams: Any {
        switch self {
        case .getRequest, .wrongURL, .withCache, .withHeaderParams:
            return [:]
        case .postWithBodyParams(let ids):
            return ["ids":ids]
        }
    }
    
    var useCache: Bool {
        switch self {
        case .getRequest, .postWithBodyParams, .wrongURL, .withHeaderParams:
            return false
        case .withCache:
            return true
        }
    }
}
