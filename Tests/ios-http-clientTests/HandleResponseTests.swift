//
//  GenericNetworkingDataSourceTests.swift
//  iOS-Generic-Datasource-Tests
//
//  Created by raulbot on 24/2/23.
//

import XCTest
@testable import ios_http_client

final class HandleResponseTests: XCTestCase {
    func test_handleResponse_success() {
        //Given
        let dataSource = MockGenericNetworkingDataSource()
        let data = String.getSuccessResponse().data(using: .utf8)
        let urlResponse = URLResponse.getURLResponseSuccess()
        var errorResponse: Error?
        var dataResponse: Data?
        //When
        do {
            dataResponse = try dataSource.handleResponse(data: data!, response: urlResponse)
        } catch {
            errorResponse = error
        }
        //Then
        XCTAssertNotNil(dataResponse)
        XCTAssertNil(errorResponse)
        XCTAssertEqual(String(decoding: dataResponse!, as: UTF8.self), String.getSuccessResponse())
    }
    
    func test_handleResponse_errorWithData() {
        //Given
        let dataSource = MockGenericNetworkingDataSource()
        let data = String.getErrorResponse().data(using: .utf8)
        let urlResponse = URLResponse.getURLResponseError()
        var errorResponse: Error?
        var dataResponse: Data?
        //When
        do {
            dataResponse = try dataSource.handleResponse(data: data!, response: urlResponse)
        } catch {
            errorResponse = error
        }
        //Then
        XCTAssertNil(dataResponse)
        XCTAssertNotNil(errorResponse)
        XCTAssertEqual((errorResponse! as NSError).domain.description, String.getErrorResponse())
        XCTAssertEqual((errorResponse! as NSError).code, (urlResponse as! HTTPURLResponse).statusCode)
    }
    
    func test_handleResponse_errorWithoutData() {
        //Given
        let dataSource = MockGenericNetworkingDataSource()
        let data = String.getEmptyResponse().data(using: .utf8)
        let urlResponse = URLResponse.getURLResponseError()
        var errorResponse: Error?
        var dataResponse: Data?
        //When
        do {
            dataResponse = try dataSource.handleResponse(data: data!, response: urlResponse)
        } catch {
            errorResponse = error
        }
        //Then
        XCTAssertNil(dataResponse)
        XCTAssertNotNil(errorResponse)
        XCTAssertNotEqual((errorResponse! as NSError).domain.description, String.getErrorResponse())
        XCTAssertEqual((errorResponse! as NSError).domain.description, DataSourceErrors.networkingRequestError.localizedDescription)
        XCTAssertEqual((errorResponse! as NSError).code, (urlResponse as! HTTPURLResponse).statusCode)
    }
    
    func test_handleResponse_errorNoHTTPURLResponse() {
        //Given
        let dataSource = MockGenericNetworkingDataSource()
        let data = String.getEmptyResponse().data(using: .utf8)
        let urlResponse = URLResponse.getNoHTTPURLResponseError()
        var errorResponse: Error?
        var dataResponse: Data?
        //When
        do {
            dataResponse = try dataSource.handleResponse(data: data!, response: urlResponse)
        } catch {
            errorResponse = error
        }
        //Then
        XCTAssertNil(dataResponse)
        XCTAssertNotNil(errorResponse)
        XCTAssertNotEqual((errorResponse! as NSError).domain.description, String.getErrorResponse())
        XCTAssertEqual((errorResponse! as! DataSourceErrors).localizedDescription, DataSourceErrors.castHTTPURLResponseException.localizedDescription)
        XCTAssertEqual((errorResponse! as! DataSourceErrors).code, DataSourceErrors.castHTTPURLResponseException.code)
    }
}
