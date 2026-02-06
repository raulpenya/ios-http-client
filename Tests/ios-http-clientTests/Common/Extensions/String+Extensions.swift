//
//  String+Extensions.swift
//  iOS-Generic-Datasource_Example
//
//  Created by raulbot on 22/3/23.
//

import Foundation

extension String {
    static func getSuccessResponse() -> String {
        return "{\"persons\":[{\"name\":\"Shyam\",\"email\":\"shyamjaiswal@gmail.com\"},{\"name\":\"Bob\",\"email\":\"bob32@gmail.com\"},{\"name\":\"Jai\",\"email\":\"jai87@gmail.com\"}]}"
    }
    
    static func getErrorResponse() -> String {
        return "404 Bad request"
    }
    
    static func getEmptyResponse() -> String {
        return ""
    }
}
