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
    private let maxResult = 30
    private let bookList = PublishRelay<[BookListItem]>()
    private let error = PublishRelay<String>()
    private let pageFinished = PublishRelay<Bool>()
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
//        let bookList: Observable<[BookListItem]>
        let cellData: Observable<[BookListCellData]>
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
        
        let cellData = Observable.combineLatest(input.selectedFilter, bookList, pageFinished).map { selectedFilter, bookList, pageFinished in
            var cellData: [BookListCellData] = []
            cellData.append(.tab(selectedFilter: selectedFilter))
            cellData += bookList.map { BookListCellData.book(book: $0, bookType: selectedFilter) }
            if !pageFinished { cellData.append(.loading)}
            return cellData
        }
        return Output(cellData: cellData, error: error.asObservable())
    }
    
    private func searchBooks(query: String, filter: BookSearchFilter, pageIndex: Int) {
        self.pageIndex = pageIndex
        Task {
            let result = await usecase.searchBooks(query: query, filter: filter, pageIndex: pageIndex, maxResult: maxResult)
            switch result {
            case .success(let bookList):
                self.bookList.accept(bookList.items)

                pageFinished.accept(bookList.items.count < maxResult)
            case .failure(let error):
                self.error.accept(error.description)
            }
        }
    }
}

public enum BookListCellData {
    case tab(selectedFilter: BookSearchFilter)
    case book(book: BookListItem, bookType: BookSearchFilter)
    case loading
    
    var cellType: BookListCellType.Type {
        switch self {
        default: BookListTableViewCell.self
        }
    }
    var id: String {
        switch self {
        default: BookListTableViewCell.identifier
        }
    }
}

protocol BookListCellType {
    func apply(cellData: BookListCellData)
}
