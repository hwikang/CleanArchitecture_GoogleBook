//
//  URLSessionProtocol.swift
//  kidsbook
//
//  Created by paytalab on 8/9/24.
//

import Foundation

public protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

public class BookURLSession: URLSessionProtocol {
    private var session: URLSession

    public init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: config)
    }
    
    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await session.data(for: request)
    }
}
