//
//  RequestCombineTests.swift
//  HTTPClientTests
//
//  Created by raulbot on 24/2/23.
//

import XCTest
@testable import HTTPClient

@MainActor
final class RequestCombineTests: XCTestCase {
    enum DataSourceResponse {
        case success
        case error
    }
    
    func test_request_success() {
        //Given
        let session = MockSession()
        session.response = .success
        let urlRequest = try! MockApi.getRequest.asURLRequest()
        let dataSource = NetworkingDataSource(session: session)
        let expectation = expectation(description: "test_request_success")
        var localResponse: DataSourceResponse?
        var localError: Error?
        var localTransformCalled = false
        let resource = Resource<PersonsRemoteEntity, [Person]>(
            request: urlRequest
        ) { persons in
            localTransformCalled = true
            return persons.transformToDomain()
        }
        
        //When
        let cancellable = dataSource
            .request(resource: resource)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        localResponse = .error
                        localError = error
                    case .finished:
                        localResponse = .success
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
        waitForExpectations(timeout: 5)
        
        //THen
        XCTAssertEqual(localResponse, .success)
        XCTAssertTrue(localTransformCalled)
        XCTAssertNil(localError)
        
        _ = cancellable
    }
    
    func test_request_error() {
        //Given
        let session = MockSession()
        session.response = .error
        let urlRequest = try! MockApi.getRequest.asURLRequest()
        let dataSource = NetworkingDataSource(session: session)
        let expectation = expectation(description: "test_request_error")
        var localResponse: DataSourceResponse?
        var localError: Error?
        var localTransformCalled = false
        let resource = Resource<PersonsRemoteEntity, [Person]>(
            request: urlRequest
        ) { persons in
            localTransformCalled = true
            return persons.transformToDomain()
        }
        
        //When
        let cancellable = dataSource
            .request(resource: resource)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        localResponse = .error
                        localError = error
                    case .finished:
                        localResponse = .success
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
        waitForExpectations(timeout: 5)
        
        //THen
        XCTAssertEqual(localResponse, .error)
        XCTAssertFalse(localTransformCalled)
        XCTAssertNotNil(localError)
        
        _ = cancellable
    }
    
    func test_request_handleResponse_error() {        
        //Given
        let session = MockSession()
        session.response = .errorHandleResponse
        let urlRequest = try! MockApi.getRequest.asURLRequest()
        let dataSource = NetworkingDataSource(session: session)
        let expectation = expectation(description: "test_request_handleResponse_error")
        var localResponse: DataSourceResponse?
        var localError: Error?
        var localTransformCalled = false
        let resource = Resource<PersonsRemoteEntity, [Person]>(
            request: urlRequest
        ) { persons in
            localTransformCalled = true
            return persons.transformToDomain()
        }
        
        //When
        let cancellable = dataSource
            .request(resource: resource)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        localResponse = .error
                        localError = error
                    case .finished:
                        localResponse = .success
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
        waitForExpectations(timeout: 5)
        
        //THen
        XCTAssertEqual(localResponse, .error)
        XCTAssertFalse(localTransformCalled)
        XCTAssertNotNil(localError)
        let networkError = try! XCTUnwrap(localError as? NetworkError)
        guard case .invalidResponse = networkError else {
            XCTFail("Expected decoding error, got \(networkError)")
            return
        }
        
        _ = cancellable
    }
    
    func test_request_decode_error() {
        //Given
        let session = MockSession()
        session.response = .errorDecode
        let urlRequest = try! MockApi.getRequest.asURLRequest()
        let dataSource = NetworkingDataSource(session: session)
        let expectation = expectation(description: "test_request_decode_error")
        var localResponse: DataSourceResponse?
        var localError: Error?
        var localTransformCalled = false
        let resource = Resource<PersonsRemoteEntity, [Person]>(
            request: urlRequest
        ) { persons in
            localTransformCalled = true
            return persons.transformToDomain()
        }
        
        //When
        let cancellable = dataSource
            .request(resource: resource)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        localResponse = .error
                        localError = error
                    case .finished:
                        localResponse = .success
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
        waitForExpectations(timeout: 5)
        
        //THen
        XCTAssertEqual(localResponse, .error)
        XCTAssertFalse(localTransformCalled)
        XCTAssertNotNil(localError)
        let networkError = try! XCTUnwrap(localError as? NetworkError)
        guard case .decoding = networkError else {
            XCTFail("Expected decoding error, got \(networkError)")
            return
        }
        
        _ = cancellable
    }
}
