//
//  BookNetwork.swift
//  kidsbook
//
//  Created by paytalab on 8/9/24.
//

import Foundation

public protocol BookNetworkProtocol {
    func searchBooks(query: String, filter: BookSearchFilter, pageIndex: Int, maxResult: Int) async -> Result<BookList, NetworkError>
}

public struct BookNetwork: BookNetworkProtocol {
    private let network: NetworkManagerProtocol
    private let endPoint = "https://api.itbook.store/1.0"
    
    public init(network: NetworkManagerProtocol) {
        self.network = network
    }
    
    public func searchBooks(query: String, filter: BookSearchFilter, pageIndex: Int, maxResult: Int) async -> Result<BookList, NetworkError> {
        let url = "https://www.googleapis.com/books/v1/volumes?q=\(query)&filter=\(filter.rawValue)&startIndex=\(pageIndex)&maxResults=\(maxResult)"
        return await network.fetchData(urlString: url, httpMethod: .get, headers: nil)
    }
}
