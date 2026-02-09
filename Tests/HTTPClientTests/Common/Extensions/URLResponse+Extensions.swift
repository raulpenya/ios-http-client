//
//  URLResponse+Extensions.swift
//  iOS-Generic-Datasource_Example
//
//  Created by raulbot on 22/3/23.
//

import Foundation

extension URLResponse {
    static func getURLResponseSuccess() -> URLResponse {
        return HTTPURLResponse(url: URL(string: MockApi.fakeBaseUrl+MockApi.fakeEndpoint)!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    static func getURLResponseError() -> URLResponse {
        return HTTPURLResponse(url: URL(string: MockApi.fakeBaseUrl+MockApi.fakeEndpoint)!, statusCode: 404, httpVersion: nil, headerFields: nil)!
    }
    
    static func getNoHTTPURLResponseError() -> URLResponse {
        return URLResponse(url: URL(string: MockApi.fakeBaseUrl+MockApi.fakeEndpoint)!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
}
