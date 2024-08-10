//
//  BookRepository.swift
//  kidsbook
//
//  Created by paytalab on 8/9/24.
//

import Foundation
public struct BookRepository: BookRepositoryProtocol {
    
    private let bookNetwork: BookNetwork
    public init(bookNetwork: BookNetwork) {
        self.bookNetwork = bookNetwork
    }
    
    public func searchBooks(query: String, filter: BookSearchFilter, pageIndex: Int, maxResult: Int) async -> Result<BookList, NetworkError> {
        await bookNetwork.searchBooks(query: query, filter: filter, pageIndex: pageIndex, maxResult: maxResult)
    }
    
}
