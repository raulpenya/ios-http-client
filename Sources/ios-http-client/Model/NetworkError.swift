//
//  DataSourceErrors.swift
//  iOS-Generic-Datasource-Tests
//
//  Created by raulbot on 24/2/23.
//

import Foundation

public enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case serverError(statusCode: Int, body: String?)
    case decoding(Error)
    case transport(Error)
}
