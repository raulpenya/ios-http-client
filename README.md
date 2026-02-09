# HTTPClient
A lightweight, testable HTTP networking client for iOS and macOS, supporting async/await and Combine.

## Installation

```swift
.package(url: "https://github.com/yourname/http-client.git", from: "1.0.0")
```

## Overview

HTTPClient provides a simple and flexible abstraction for executing HTTP requests while keeping:
- Networking logic isolated
- Mapping between remote DTOs and domain models explicit
- The codebase highly testable

### NetworkingProtocol

`NetworkingProtocol` defines the public API of the client and supports both concurrency models:

  - `await/async`:
  ```swift
  func request<T: Decodable, Q>(
        resource: Resource<T, Q>
    ) async throws -> Q
  ```
  - `Combine`:
  ```swift
  func request<T: Decodable, Q>(
        resource: Resource<T, Q>
    ) -> AnyPublisher<Q, Error>
  ```
Both methods execute a request, decode the response into a remote entity, and transform it into a domain model.

### Resource

A Resource encapsulates everything needed to perform a request and map its result:
```swift
struct Resource<T: Decodable, Q> {
    let request: URLRequest
    let transform: (T) -> Q
}
```
Generic parameters
- T: Remote DTO type (must conform to Decodable)
- Q: Domain model returned by the client

The transform closure allows mapping from a remote representation (T) to a domain entity (Q), enforcing a clear separation between layers.

This explicit distinction follows Clean Architecture principles and avoids leaking networking concerns into the domain layer.

### NetworkingDataSource

`NetworkingDataSource` is the default implementation of `NetworkingProtocol`.

It receives a `Session` abstraction via dependency injection, allowing you to use `URLSession` in production and a mock session in tests.
```swift
public protocol Session {
    typealias RequestResponse = URLSession.DataTaskPublisher.Output
    func data(for url: URLRequest) async throws -> (Data, URLResponse)
    func executeTaskPublisher(for request: URLRequest) -> AnyPublisher<RequestResponse, URLError>
}
```
`URLSession` already conforms to `Session`:
```swift
extension URLSession: Session {
    public func data(for url: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: url, delegate: nil)
    }
    public func executeTaskPublisher(for request: URLRequest) -> AnyPublisher<RequestResponse, URLError> {
        return dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}
```
#### Initializer
```swift
public init(
    session: Session = URLSession.shared,
    decoder: JSONDecoder = .init()
) {
    self.session = session
    self.decoder = decoder
}
```

## Usage
`Async/Await` example:
```swift
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
 }
```
`Combine` example:
```swift
func getAllPersons() -> AnyPublisher<[Person], Error> {
    let request = try! PersonsApi.getAllPersons.asURLRequest()
    let resource = Resource<PersonsRemoteEntity, [Person]>(request: request) { persons in
        return persons.transformToDomain()
    }
    return client.request(resource: resource)
}
```

## Error Handling

The client surfaces networking, decoding, and HTTP errors through strongly typed errors, making them easy to assert in unit tests.

## Testing

Thanks to the Session abstraction, the client is easy to test by injecting a mock session that returns controlled responses.
The repository includes a demo app and unit tests showcasing both async/await and Combine usage.

## Demo

For more details take a look at the demo app inside the repository.