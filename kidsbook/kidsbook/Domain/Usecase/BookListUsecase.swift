//
//  BookListUsecase.swift
//  kidsbook
//
//  Created by paytalab on 8/9/24.
//

import Foundation

public protocol BookListUsecaseProtocol {
    func searchBooks(query: String, filter: BookSearchFilter, pageIndex: Int, maxResult: Int) async -> Result<BookList, NetworkError>
}
public struct BookListUsecase: BookListUsecaseProtocol {
    
    private let repository: BookRepositoryProtocol
    public init(repository: BookRepositoryProtocol) {
        self.repository = repository
    }
    
    public func searchBooks(query: String, filter: BookSearchFilter, pageIndex: Int, maxResult: Int) async -> Result<BookList, NetworkError> {
        await repository.searchBooks(query: query, filter: filter, pageIndex: pageIndex, maxResult: maxResult)
    }
    
}
