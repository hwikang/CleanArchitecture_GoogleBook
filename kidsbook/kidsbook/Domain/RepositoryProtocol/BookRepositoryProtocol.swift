//
//  BookRepositoryProtocol.swift
//  kidsbook
//
//  Created by paytalab on 8/9/24.
//

import Foundation

public protocol BookRepositoryProtocol {
    func searchBooks(query: String, filter: BookSearchFilter, pageIndex: Int) async -> Result<BookList, NetworkError>
}
