//
//  RequestAwaitAsyncTests.swift
//  iOS-Generic-Datasource-Tests
//
//  Created by raulbot on 24/2/23.
//

import XCTest
@testable import HTTPClient

final class RequestAwaitAsyncTests: XCTestCase {

    let session = MockSession()
    var dataSource: NetworkingDataSource?
    var transformCalled = false
    var urlRequest: URLRequest?
    var resource: Resource<PersonsRemoteEntity, [Person]>?
    
    override func setUpWithError() throws {
        urlRequest = try! MockApi.getRequest.asURLRequest()
        resource = Resource<PersonsRemoteEntity, [Person]>(request: urlRequest!) { [weak self] persons in
            self?.transformCalled = true
            return persons.transformToDomain()
        }
        transformCalled = false
        dataSource = NetworkingDataSource(session: session)
    }
    
    func test_request_success() async throws {
        //Given
        session.response = .success
        //When
        let persons = try await dataSource!.request(resource: resource!)
        //Then
        XCTAssertTrue(transformCalled)
        XCTAssertFalse(persons.isEmpty)
    }
    
    func test_request_error() async {
        //Given
        session.response = .error
        do {
            //When
            _ = try await dataSource!.request(resource: resource!)
            XCTFail("Expected error")
        } catch let error as NetworkError {
            //Then
            XCTAssertFalse(transformCalled)
            XCTAssertNotNil(error)
            XCTAssertEqual(error, .invalidRequest)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    func test_request_handleResponse_error() async {
        //Given
        session.response = .errorHandleResponse
        //When
        do {
            //When
            _ = try await dataSource!.request(resource: resource!)
            XCTFail("Expected error")
        } catch let error as NetworkError {
            //Then
            XCTAssertFalse(transformCalled)
            XCTAssertEqual(error, .invalidResponse)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    func test_request_decode_error() async {
        //Given
        session.response = .errorDecode
        //When
        do {
            //When
            _ = try await dataSource!.request(resource: resource!)
            XCTFail("Expected decoding error")
        } catch let error as DecodingError {
            //Then
            XCTAssertFalse(transformCalled)
        } catch {
            XCTFail("Expected DecodingError, got \(type(of: error))")
        }
    }
}
