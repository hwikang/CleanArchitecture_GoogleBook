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
}

public class BookDetailViewModel: BookDetailViewModelProtocol {
    
    private let book: BookListItem
    //    private let book = PublishRelay<BookListItem>()
    private let error = PublishRelay<String>()
    private let loading = PublishRelay<Bool>()
    
    public init(book: BookListItem) {
        
        self.book = book
        
    }
    public struct Input {
        
    }
    
    public struct Output {
        //        let book: Observable<BookDetail>
        let error: Observable<String>
        //        let loading: Observable<Bool>
        
    }
    
    public func transform(input: Input) -> Output {
        return Output(error: error.asObservable())
    }
    
}
