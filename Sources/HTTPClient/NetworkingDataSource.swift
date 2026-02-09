//
//  GenericNetworkingDataSource.swift
//  iOS-Generic-Datasource_Example
//
//  Created by raulbot on 6/2/23.
//

import Foundation
import Combine

public protocol NetworkingProtocol {
    func request<T: Decodable, Q>(
        resource: Resource<T, Q>
    ) async throws -> Q
    
    func request<T: Decodable, Q>(
        resource: Resource<T, Q>
    ) -> AnyPublisher<Q, Error>
}

public final class NetworkingDataSource: NetworkingProtocol {
    
    private let session: Session
    private let decoder: JSONDecoder
    
    public init(
        session: Session = URLSession.shared,
        decoder: JSONDecoder = .init()
    ) {
        self.session = session
        self.decoder = decoder
    }
    
    public func request<T: Decodable, Q>(
        resource: Resource<T, Q>
    ) async throws -> Q {
        do {
            let (data, response) = try await session.data(for: resource.request)
            let validated = try Self.validate(data: data, response: response)
            let entity = try decoder.decode(T.self, from: validated)
            return resource.transform(entity)
        } catch let error as NetworkError {
            throw error
        } catch let error as DecodingError {
            throw NetworkError.decoding(error)
        } catch {
            throw NetworkError.transport(error)
        }
    }
    
    public func request<T: Decodable, Q>(
        resource: Resource<T, Q>
    ) -> AnyPublisher<Q, Error> {
        session.executeTaskPublisher(for: resource.request)
            .tryMap(Self.validate)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else if let decodingError = error as? DecodingError {
                    return NetworkError.decoding(decodingError)
                } else {
                    return NetworkError.transport(error)
                }
            }
            .map(resource.transform)
            .eraseToAnyPublisher()
    }
}

extension NetworkingDataSource {
    public static func validate(data: Data, response: URLResponse) throws -> Data {
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard (200..<300).contains(http.statusCode) else {
            let bodyString = String(data: data, encoding: .utf8)
            let body = bodyString?.isEmpty == true ? nil : bodyString
            throw NetworkError.serverError(
                statusCode: http.statusCode,
                body: body
            )
        }
        return data
    }
}
