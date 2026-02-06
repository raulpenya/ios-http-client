//
//  ValidateTests.swift
//  HTTPClientTests
//
//  Created by raulbot on 24/2/23.
//

import XCTest
@testable import HTTPClient

final class ValidateTests: XCTestCase {
    func test_validate_success() {
        //Given
        let data = String.getSuccessResponse().data(using: .utf8)
        let urlResponse = URLResponse.getURLResponseSuccess()
        var errorResponse: Error?
        var dataResponse: Data?
        //When
        do {
            dataResponse = try NetworkingDataSource.validate(data: data!, response: urlResponse)
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
        let data = String.getErrorResponse().data(using: .utf8)
        let urlResponse = URLResponse.getURLResponseError()
        var errorResponse: Error?
        var dataResponse: Data?
        //When
        do {
            dataResponse = try NetworkingDataSource.validate(data: data!, response: urlResponse)
        } catch {
            errorResponse = error
        }
        //Then
        XCTAssertNil(dataResponse)
        XCTAssertNotNil(errorResponse)
        guard case let .serverError(code, body) = errorResponse as? NetworkError else {
            XCTFail("Expected serverError")
            return
        }
        XCTAssertEqual(code, (urlResponse as! HTTPURLResponse).statusCode)
        XCTAssertEqual(body, String.getErrorResponse())
    }
    
    func test_handleResponse_errorWithoutData() {
        //Given
        let data = String.getEmptyResponse().data(using: .utf8)
        let urlResponse = URLResponse.getURLResponseError()
        var errorResponse: Error?
        var dataResponse: Data?
        //When
        do {
            dataResponse = try NetworkingDataSource.validate(data: data!, response: urlResponse)
        } catch {
            errorResponse = error
        }
        //Then
        XCTAssertNil(dataResponse)
        XCTAssertNotNil(errorResponse)
        if let code = (errorResponse as? NetworkError)?.statusCode {
            XCTAssertEqual(code, (urlResponse as! HTTPURLResponse).statusCode)
        }
        XCTAssertNil((errorResponse as? NetworkError)?.body)
    }
    
    func test_handleResponse_errorNoHTTPURLResponse() {
        //Given
        let data = String.getEmptyResponse().data(using: .utf8)
        let urlResponse = URLResponse.getNoHTTPURLResponseError()
        var errorResponse: Error?
        var dataResponse: Data?
        //When
        do {
            dataResponse = try NetworkingDataSource.validate(data: data!, response: urlResponse)
        } catch {
            errorResponse = error
        }
        //Then
        XCTAssertNil(dataResponse)
        XCTAssertNotNil(errorResponse)
        XCTAssertEqual((errorResponse as? NetworkError), NetworkError.invalidResponse)
    }
}
