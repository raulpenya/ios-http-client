//
//  RequestAwaitAsyncTests.swift
//  iOS-Generic-Datasource-Tests
//
//  Created by raulbot on 24/2/23.
//

import XCTest
@testable import ios_http_client

final class RequestAwaitAsyncTests: XCTestCase {

    let dataSource = MockGenericNetworkingDataSource()
    let session = MockSession()
    var transformCalled = false
    var response: DataSourceResponse?
    var errorResponse: Error?
    var urlRequest: URLRequest?
    var resource: Resource<PersonsRemoteEntity, [Person]>?
    
    override func setUpWithError() throws {
        urlRequest = try! MockApi.getRequest.asURLRequest()
        resource = Resource<PersonsRemoteEntity, [Person]>(request: urlRequest!) { [weak self] persons in
            self?.transformCalled = true
            return persons.transformToDomain()
        }
        transformCalled = false
        response = nil
        errorResponse = nil
    }
    
    func test_request_success() {
        //Given
        session.response = .success
        let expectation = expectation(description: "test_request_success")
        //When
        Task {
            do {
                let persons = try await dataSource.request(with: session, resource: resource)
                print(persons)
                response = .success
            } catch {
                print(error)
                errorResponse = error
                response = .error
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        //Then
        XCTAssertEqual(response, .success)
        XCTAssertTrue(transformCalled)
        XCTAssertNil(errorResponse)
    }
    
    func test_request_noresource_error() {
        //Given
        session.response = .success
        let expectation = expectation(description: "test_request_noresource_error")
        resource = nil
        //When
        Task {
            do {
                let persons = try await dataSource.request(with: session, resource: resource)
                print(persons)
                response = .success
            } catch {
                print(error)
                errorResponse = error
                response = .error
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        //Then
        XCTAssertEqual(response, .error)
        XCTAssertFalse(transformCalled)
        XCTAssertNotNil(errorResponse)
        XCTAssertNotEqual((errorResponse! as NSError).domain.description, String.getErrorResponse())
        XCTAssertEqual((errorResponse! as! DataSourceErrors).localizedDescription, DataSourceErrors.requestException.localizedDescription)
        XCTAssertEqual((errorResponse! as! DataSourceErrors).code, DataSourceErrors.requestException.code)
    }
    
    func test_request_error() {
        //Given
        session.response = .error
        let expectation = expectation(description: "test_request_error")
        //When
        Task {
            do {
                let persons = try await dataSource.request(with: session, resource: resource)
                print(persons)
                response = .success
            } catch {
                print(error)
                errorResponse = error
                response = .error
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        //Then
        XCTAssertEqual(response, .error)
        XCTAssertFalse(transformCalled)
        XCTAssertNotNil(errorResponse)
    }
    
    func test_request_handleResponse_error() {
        //Given
        session.response = .errorHandleResponse
        let expectation = expectation(description: "test_request_handleResponse_error")
        //When
        Task {
            do {
                let persons = try await dataSource.request(with: session, resource: resource)
                print(persons)
                response = .success
            } catch {
                print(error)
                errorResponse = error
                response = .error
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        //Then
        XCTAssertEqual(response, .error)
        XCTAssertFalse(transformCalled)
        XCTAssertNotNil(errorResponse)
        XCTAssertNotEqual((errorResponse! as NSError).domain.description, String.getErrorResponse())
        XCTAssertEqual((errorResponse! as! DataSourceErrors).localizedDescription, DataSourceErrors.castHTTPURLResponseException.localizedDescription)
        XCTAssertEqual((errorResponse! as! DataSourceErrors).code, DataSourceErrors.castHTTPURLResponseException.code)
    }
    
    func test_request_decode_error() {
        //Given
        session.response = .errorDecode
        let expectation = expectation(description: "test_request_decode_error")
        //When
        Task {
            do {
                let persons = try await dataSource.request(with: session, resource: resource)
                print(persons)
                response = .success
            } catch {
                print(error)
                errorResponse = error
                response = .error
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        //Then
        XCTAssertEqual(response, .error)
        XCTAssertFalse(transformCalled)
        XCTAssertNotNil(errorResponse)
    }
}

