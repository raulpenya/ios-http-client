WIP

# ios-http-client
A lightweight, testable HTTP networking client supporting async/await and Combine.

## Installation

```swift
.package(url: "https://github.com/yourname/http-client.git", from: "1.0.0")
```

## Usage

```
let client = NetworkingDataSource()
let value = try await client.request(resource: resource)
```
