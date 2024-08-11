//
//  BookListViewController.swift
//  kidsbook
//
//  Created by paytalab on 8/9/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BookListViewController: UIViewController {
    private let viewModel: BookListViewModelProtocol
    private let selectedTabType = BehaviorRelay<BookSearchFilter>(value: .freeEbook)
    private let disposeBag = DisposeBag()
    private let searchTextfield = SearchTextField()
    private let textfieldBorder = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    private let pullToRefreshControl = UIRefreshControl()

    private let tableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.register(TabTableViewCell.self, forCellReuseIdentifier: TabTableViewCell.identifier)
        tableView.register(BookListTableViewCell.self, forCellReuseIdentifier: BookListTableViewCell.identifier)
        tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: LoadingTableViewCell.identifier)
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        tableView.register(EmptyResultTableViewCell.self, forCellReuseIdentifier: EmptyResultTableViewCell.identifier)
        return tableView
    }()
    
    init(viewModel: BookListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setUI()
        bindViewModel()
        bindView()
    }
    
    private func bindViewModel() {
        let refreshTrigger = pullToRefreshControl.rx.controlEvent(.valueChanged).filter {
            [unowned self] in pullToRefreshControl.isRefreshing
        }
        let output = viewModel.transform(input: BookListViewModel.Input(
            keyword: searchTextfield.rx.controlEvent(.editingDidEnd).withLatestFrom(searchTextfield.rx.text.orEmpty),
            selectedFilter: selectedTabType.asObservable(), refreshTrigger: refreshTrigger,
            fetchMoreTrigger: tableView.rx.willDisplayCell.filter { $0.cell is LoadingTableViewCell }
                .debounce(.milliseconds(1000), scheduler: MainScheduler.instance).map { _ in () }))
        
        output.cellData
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items) { tableView, _, element in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: element.id) else { return UITableViewCell() }
            (cell as? BookListCellType)?.apply(cellData: element)
            if let cell = cell as? TabTableViewCell {
                cell.selectedTab.bind { [weak self] selectedFilter in
                    self?.selectedTabType.accept(selectedFilter)
                }.disposed(by: cell.disposeBag)
            }
            return cell
        }.disposed(by: disposeBag)
                                         
        output.loading.observe(on: MainScheduler.instance)
            .filter { [unowned self] _ in pullToRefreshControl.isRefreshing }
            .bind(to: pullToRefreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        output.error.observe(on: MainScheduler.instance).bind { [weak self] error in
            let alert = UIAlertController(title: "에러", message: error, preferredStyle: .alert)
            alert.addAction(.init(title: "확인", style: .default))
            self?.present(alert, animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func bindView() {
        tableView.rx.modelSelected(BookListCellData.self).bind { [weak self] cellData in
            if case let .book(book , _) = cellData {
                self?.pushBookDetailVC(book: book)

            }
        }.disposed(by: disposeBag)
    }
    
    private func setUI() {
        view.addSubview(searchTextfield)
        view.addSubview(textfieldBorder)
        view.addSubview(tableView)
        tableView.refreshControl = pullToRefreshControl
        setConstraints()
    }
    
    private func setConstraints() {
        searchTextfield.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        textfieldBorder.snp.makeConstraints { make in
            make.top.equalTo(searchTextfield.snp.bottom)
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textfieldBorder.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func pushBookDetailVC(book: BookListItem) {
       
        let bookVM = BookDetailViewModel(book: book)
        let BookVC = BookDetailViewController(viewModel: bookVM)
        navigationController?.pushViewController(BookVC, animated: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

