//
//  ExampleDataSource.swift
//  HTTPClientExampleApp
//
//  Created by Raul Peña on 6/2/26.
//

import Foundation
import Combine
import HTTPClient

final class ExampleDataSource {
    private let client: NetworkingProtocol
    
    init(client: NetworkingProtocol = NetworkingDataSource()) {
        self.client = client
    }

    func getAllPersons() async throws -> [Person] {
        let request = try! PersonsApi.getAllPersons.asURLRequest()
        let resource = Resource<PersonsRemoteEntity, [Person]>(request: request) { persons in
            return persons.transformToDomain()
        }
        return try await client.request(resource: resource)
    }
    
    func getAllPersonsWithCache() async throws -> [Person] {
        let request = try! PersonsApi.getAllPersonsWithCache.asURLRequest()
        let resource = Resource<PersonsRemoteEntity, [Person]>(request: request) { persons in
            return persons.transformToDomain()
        }
        return try await client.request(resource: resource)
    }
    
    func getAllPersons() -> AnyPublisher<[Person], Error> {
        let request = try! PersonsApi.getAllPersons.asURLRequest()
        let resource = Resource<PersonsRemoteEntity, [Person]>(request: request) { persons in
            return persons.transformToDomain()
        }
        return client.request(resource: resource)
    }
}
