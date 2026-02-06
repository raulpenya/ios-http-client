//
//  Resource.swift
//  Data
//
//  Created by raulbot on 4/3/23.
//

import Foundation

public struct Resource<Response: Decodable, Output> {
    public let request: URLRequest
    public let transform: (Response) -> Output
    
    public init(
        request: URLRequest,
        transform: @escaping (Response) -> Output
    ) {
        self.request = request
        self.transform = transform
    }
}
