//
//  Person.swift
//  iOS-Generic-Datasource_Example
//
//  Created by raulbot on 8/2/23.
//

import Foundation

struct PersonRemoteEntity: Decodable {
    let name: String
    let email: String
}

extension PersonRemoteEntity {
    func transformToDomain() -> Person {
        return Person(name: name, email: email)
    }
}

struct Person {
    let name: String
    let email: String
}
