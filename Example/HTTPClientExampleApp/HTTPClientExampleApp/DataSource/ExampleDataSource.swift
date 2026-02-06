//
//  ExampleDataSource.swift
//  HTTPClientExampleApp
//
//  Created by Raul Peña on 6/2/26.
//

import Foundation
import Combine
import HTTPClient

class ExampleDataSource {
    
    static let personsArray = "https://10225bfa-a047-4ea0-9ded-715308e698e3.mock.pstmn.io/person/all"
    static let personsError = "https://10225bfa-a047-4ea0-9ded-715308e698e3.mock.pstmn.io/person/error"
    
    private let client: NetworkingProtocol
    
    init(client: NetworkingProtocol = NetworkingDataSource()) {
        self.client = client
    }

    func getAllPersons() async throws -> [Person] {
        let request = URLRequest(url: URL(string: ExampleDataSource.personsArray)!)
        let resource = Resource<PersonsRemoteEntity, [Person]>(request: request) { persons in
            return persons.transformToDomain()
        }
        return try await client.request(resource: resource)
    }
    
    func getAllPersons() -> AnyPublisher<[Person], Error> {
        let request = URLRequest(url: URL(string: ExampleDataSource.personsArray)!)
        let resource = Resource<PersonsRemoteEntity, [Person]>(request: request) { persons in
            return persons.transformToDomain()
        }
        return client.request(resource: resource)
    }
}
