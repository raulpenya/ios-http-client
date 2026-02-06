//
//  DataSourceErrors.swift
//  iOS-Generic-Datasource-Tests
//
//  Created by raulbot on 24/2/23.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case invalidRequest
    case invalidResponse
    case serverError(statusCode: Int, body: String?)
    case decoding(Error)
    case transport(Error)
    
    
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidRequest, .invalidRequest),
            (.invalidResponse, .invalidResponse):
            return true
            
        case let (.serverError(lCode, lBody), .serverError(rCode, rBody)):
            return lCode == rCode && lBody == rBody
            
        case (.decoding, .decoding),
            (.transport, .transport):
            return true
            
        default:
            return false
        }
    }
}

extension NetworkError {
    public var statusCode: Int? {
        if case let .serverError(code, _) = self {
            return code
        }
        return nil
    }
    
    public var body: String? {
        if case let .serverError(_, body) = self {
            return body
        }
        return nil
    }
}
