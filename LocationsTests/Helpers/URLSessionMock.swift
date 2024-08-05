//
//  URLSessionMock.swift
//  LocationsTests
//
//  Created by Mohammed Alwaili on 05/08/2024.
//

import Foundation

func makeURLSessionMock() -> URLSession {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [URLProtocolMock.self]
    return URLSession(configuration: configuration)
}
