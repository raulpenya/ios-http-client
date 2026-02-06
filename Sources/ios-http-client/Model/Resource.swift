//
//  Resource.swift
//  Data
//
//  Created by raulbot on 4/3/23.
//

import Foundation

public struct Resource<Response: Decodable, Output> {
    let request: URLRequest
    let transform: (Response) -> Output
}
