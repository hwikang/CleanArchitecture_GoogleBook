//
//  BookDetailViewController.swift
//  kidsbook
//
//  Created by paytalab on 8/10/24.
//

import UIKit
import RxSwift

class BookDetailViewController: UIViewController {
    private let viewModel: BookDetailViewModelProtocol
    private let disposeBag = DisposeBag()
    private let stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private lazy var headerView = BookDetailHeaderView(book: viewModel.book)
    private lazy var linkView = BookDetailLinkView(hasSample: viewModel.book.pdf?.isAvailable == true)
    init(viewModel: BookDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        setUI()
    }
    
    private func bindView() {
        linkView.buyLinkButton.rx.tap.bind { [weak self] in
            if let link = self?.viewModel.book.buyLink {
                self?.pushWebVC(link: link)
            }
        }.disposed(by: disposeBag)
        linkView.sampleButton.rx.tap.bind { [weak self] in
            if let link = self?.viewModel.book.pdf?.downloadLink {
                self?.pushWebVC(link: link)
            }
        }.disposed(by: disposeBag)
    }
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        [headerView, linkView].forEach { stackView.addArrangedSubview($0) }
        setConstraints()
    }
    
    private func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func pushWebVC(link: String) {
        let webVC = WebViewController(url: link)
        navigationController?.pushViewController(webVC, animated: true)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

