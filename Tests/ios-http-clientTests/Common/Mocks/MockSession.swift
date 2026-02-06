//
//  MockSession.swift
//  Data
//
//  Created by raulbot on 5/3/23.
//

import Foundation
import Combine
@testable import ios_http_client

class MockSession: Session {
    
    enum Response {
        case success
        case error
        case errorHandleResponse
        case errorDecode
    }
    
    var response: Response = .success
    
    func data(for url: URLRequest) async throws -> (Data, URLResponse) {
        switch response {
        case .success:
            return (String.getSuccessResponse().data(using: .utf8)!, URLResponse.getURLResponseSuccess())
        case .error:
            throw NetworkError.invalidRequest
        case .errorHandleResponse:
            return ((String.getSuccessResponse().data(using: .utf8)!, URLResponse.getNoHTTPURLResponseError()))
        case .errorDecode:
            return ((String.getEmptyResponse().data(using: .utf8)!, URLResponse.getURLResponseSuccess()))
        }
    }
    
    func executeTaskPublisher(for request: URLRequest) -> AnyPublisher<RequestResponse, URLError> {
        switch response {
        case .success:
            return Result.Publisher((String.getSuccessResponse().data(using: .utf8)!, URLResponse.getURLResponseSuccess())).eraseToAnyPublisher()
        case .error:
            return Fail(error: URLError(.timedOut)).eraseToAnyPublisher()
        case .errorHandleResponse:
            return Result.Publisher((String.getSuccessResponse().data(using: .utf8)!, URLResponse.getNoHTTPURLResponseError())).eraseToAnyPublisher()
        case .errorDecode:
            return Result.Publisher((String.getEmptyResponse().data(using: .utf8)!, URLResponse.getURLResponseSuccess())).eraseToAnyPublisher()
        }
    }
}
