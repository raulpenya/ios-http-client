//
//  ApiTests.swift
//  iOS-Generic-Datasource-Tests
//
//  Created by raulbot on 22/3/23.
//

import XCTest
@testable import HTTPClient

final class ApiTests: XCTestCase {
    var urlRequest: URLRequest?
    var apiError: Error?
    
    override func setUpWithError() throws {
        urlRequest = nil
        apiError = nil
    }
    
    func test_createURLRequest_success() {
        //Given
        let api = MockApi.getRequest
        //When
        do {
            urlRequest = try api.asURLRequest()
        } catch {
            apiError = error
        }
        //Then
        XCTAssertNil(apiError)
        XCTAssertNotNil(urlRequest)
        XCTAssertNotNil(urlRequest?.url?.absoluteString.isEmpty)
        XCTAssertNil(urlRequest?.httpBody)
        XCTAssertEqual(urlRequest?.cachePolicy, .useProtocolCachePolicy)
        XCTAssertEqual(urlRequest?.httpMethod, HTTPMethod.get.rawValue)
    }
    
    func test_createURLRequest_URLError() {
        //Given
        let api = MockApi.wrongURL
        //When
        do {
            urlRequest = try api.asURLRequest()
        } catch {
            apiError = error
        }
        //Then
        XCTAssertNotNil(apiError)
        XCTAssertEqual((apiError as? DataSourceErrors), DataSourceErrors.apiURLException)
        XCTAssertNil(urlRequest)
    }
    
    func test_createURLRequest_withCache() {
        //Given
        let api = MockApi.withCache
        //When
        do {
            urlRequest = try api.asURLRequest()
        } catch {
            apiError = error
        }
        //Then
        XCTAssertNil(apiError)
        XCTAssertNotNil(urlRequest)
        XCTAssertEqual(urlRequest?.cachePolicy, .returnCacheDataElseLoad)
    }
    
    func test_createURLRequest_withHeaderParams() {
        //Given
        let start = 0
        let count = 20
        let sort = "-PublicationStartDate"
        let api = MockApi.withHeaderParams(start, count, sort)
        //When
        do {
            urlRequest = try api.asURLRequest()
        } catch {
            apiError = error
        }
        //Then
        XCTAssertNil(apiError)
        XCTAssertNotNil(urlRequest)
        XCTAssertNotNil(urlRequest?.url?.absoluteString.isEmpty)
        XCTAssertNil(urlRequest?.httpBody)
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?.count, 5)
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Accept"], "application/json")
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Start"], String(start))
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Count"], String(count))
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Sort"], sort)
        XCTAssertEqual(urlRequest?.cachePolicy, .useProtocolCachePolicy)
        XCTAssertEqual(urlRequest?.httpMethod, HTTPMethod.get.rawValue)
    }
    
    func test_createURLRequest_withBody() {
        //Given
        let ids = ["1","2","3"]
        let api = MockApi.postWithBodyParams(ids)
        //When
        do {
            urlRequest = try api.asURLRequest()
        } catch {
            apiError = error
        }
        //Then
        XCTAssertNil(apiError)
        XCTAssertNotNil(urlRequest)
        XCTAssertNotNil(urlRequest?.httpBody)
        XCTAssertEqual(urlRequest?.httpMethod, HTTPMethod.post.rawValue)
    }
}
