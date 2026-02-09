//
//  Session.swift
//  iOS-Generic-Datasource_Example
//
//  Created by raulbot on 28/2/23.
//

import Foundation
import Combine

public protocol Session {
    typealias RequestResponse = URLSession.DataTaskPublisher.Output
    func data(for url: URLRequest) async throws -> (Data, URLResponse)
    func executeTaskPublisher(for request: URLRequest) -> AnyPublisher<RequestResponse, URLError>
}

extension URLSession: Session {
    public func data(for url: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: url, delegate: nil)
    }
    public func executeTaskPublisher(for request: URLRequest) -> AnyPublisher<RequestResponse, URLError> {
        return dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}
