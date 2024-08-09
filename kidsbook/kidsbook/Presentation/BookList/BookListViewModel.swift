//
//  BookListViewModel.swift
//  kidsbook
//
//  Created by paytalab on 8/9/24.
//

import Foundation
import RxSwift
import RxCocoa

public protocol BookListViewModelProtocol {
    func transform(input: BookListViewModel.Input) -> BookListViewModel.Output
}

public class BookListViewModel: BookListViewModelProtocol {
    private let usecase: BookListUsecaseProtocol
    private var pageIndex = 0   
    private let bookList = PublishRelay<[BookListItem]>()
    private let error = PublishRelay<String>()
    private let disposeBag = DisposeBag()

    public init(usecase: BookListUsecaseProtocol) {
        self.usecase = usecase
    }
    
    public struct Input {
        let keyword: Observable<String>
        let selectedFilter: Observable<BookSearchFilter>
        let refreshTrigger: Observable<Void>
        let fetchMoreTrigger: Observable<Void>
    }
    
    public struct Output {
        let bookList: Observable<[BookListItem]>
        let error: Observable<String>
    }
    
    public func transform(input: Input) -> Output {
        let queryDataObservable = Observable.combineLatest(input.selectedFilter, input.keyword)
        queryDataObservable.bind { [weak self] filter, keyword in
            self?.searchBooks(query: keyword, filter: filter, pageIndex: 1)
        }.disposed(by: disposeBag)
        
        input.refreshTrigger.withLatestFrom(queryDataObservable)
            .bind { [weak self] filter, keyword in
                self?.searchBooks(query: keyword, filter: filter, pageIndex: 1)
            }.disposed(by: disposeBag)
        
        input.fetchMoreTrigger.withLatestFrom(queryDataObservable)
            .bind { [weak self] filter, keyword in
                guard let self = self else { return }
                searchBooks(query: keyword, filter: filter, pageIndex: pageIndex + 1)
            }.disposed(by: disposeBag)
        return Output(bookList: bookList.asObservable(), error: error.asObservable())
    }
    
    private func searchBooks(query: String, filter: BookSearchFilter, pageIndex: Int) {
        self.pageIndex = pageIndex
        Task {
            let result = await usecase.searchBooks(query: query, filter: filter, pageIndex: pageIndex)
            switch result {
            case .success(let bookList):
                self.bookList.accept(bookList.items)
            case .failure(let error):
                self.error.accept(error.description)
            }
        }
    }
}
