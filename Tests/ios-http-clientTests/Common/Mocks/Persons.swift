//
//  Persons.swift
//  iOS-Generic-Datasource_Example
//
//  Created by raulbot on 8/2/23.
//

import Foundation

struct PersonsRemoteEntity: Decodable {
    let persons: [PersonRemoteEntity]
    
    enum CodingKeys: String, CodingKey {
        case persons
    }
}

extension PersonsRemoteEntity {
    func transformToDomain() -> [Person] {
        return persons.compactMap { $0.transformToDomain() }
    }
}
