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
    private let tabType = BehaviorRelay<BookSearchFilter>(value: .freeEbook)
    private let disposeBag = DisposeBag()
    private let searchTextfield = SearchTextField()
    private let textfieldBorder = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    private let tableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.register(BookListTableViewCell.self, forCellReuseIdentifier: BookListTableViewCell.identifier)
        return tableView
    }()
    
    init(viewModel: BookListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setUI()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: BookListViewModel.Input(
            keyword: searchTextfield.rx.text.orEmpty.distinctUntilChanged().debounce(.milliseconds(300), scheduler: MainScheduler.instance),
            selectedFilter: tabType.asObservable(), refreshTrigger: Observable.just(()), fetchMoreTrigger: Observable.just(())))
        output.cellData.bind(to: tableView.rx.items) { tableView, _, element in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: element.id) else { return UITableViewCell() }
            (cell as? BookListCellType)?.apply(cellData: element)

            return cell
        }.disposed(by: disposeBag)
                                         
                                         
    }
    
    private func setUI() {
        view.addSubview(searchTextfield)
        view.addSubview(textfieldBorder)
        view.addSubview(tableView)
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

