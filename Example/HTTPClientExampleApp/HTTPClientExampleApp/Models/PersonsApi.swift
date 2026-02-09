//
//  PersonsApi.swift
//  HTTPClientExampleApp
//
//  Created by Raul Peña on 9/2/26.
//

import Foundation
import HTTPClient

enum PersonsApi: Api {
    static let baseUrl = "https://10225bfa-a047-4ea0-9ded-715308e698e3.mock.pstmn.io/"
    
    case getAllPersons
    case getAllPersonsWithCache
    
    var method: HTTPMethod {
        switch self {
        case .getAllPersons, .getAllPersonsWithCache:
            return .get
        }
    }
    
    var url: String {
        switch self {
        case .getAllPersons, .getAllPersonsWithCache:
            return PersonsApi.baseUrl + "person/all"
        }
    }
    
    var headerParams: [String : Any] {
        switch self {
        case .getAllPersons, .getAllPersonsWithCache:
            return [:]
        }
    }
    
    var bodyParams: Any {
        switch self {
        case .getAllPersons, .getAllPersonsWithCache:
            return [:]
        }
    }
    
    var useCache: Bool {
        switch self {
        case .getAllPersons:
            return false
        case .getAllPersonsWithCache:
            return true
        }
    }
}
