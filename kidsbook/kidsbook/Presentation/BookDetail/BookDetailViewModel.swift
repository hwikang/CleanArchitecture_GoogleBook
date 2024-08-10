//
//  BookDetailViewModel.swift
//  kidsbook
//
//  Created by paytalab on 8/10/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol BookDetailViewModelProtocol {
    func transform(input: BookDetailViewModel.Input) -> BookDetailViewModel.Output
    var book: BookListItem { get }
}

public class BookDetailViewModel: BookDetailViewModelProtocol {
    
    public let book: BookListItem
    private let error = PublishRelay<String>()
    private let loading = PublishRelay<Bool>()
    
    public init(book: BookListItem) {
        self.book = book
    }
    public struct Input {
    }
    
    public struct Output {
        let error: Observable<String>
        
    }
    
    public func transform(input: Input) -> Output {
        return Output(error: error.asObservable())
    }
    
}
