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
    private let shareButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        return button
    }()
    private let stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private lazy var headerView = BookDetailHeaderView(book: viewModel.book)
    private lazy var linkView = BookDetailLinkView(hasSample: viewModel.book.pdf?.downloadLink != nil)
    private lazy var descriptionView = BookDetailDescriptionView(descriptionString: viewModel.book.description)
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
        shareButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let shareText = "\(viewModel.book.title) 사러 가기\n 링크 - \(viewModel.book.buyLink)"
            var shareObject = [Any]()
            shareObject.append(shareText)
            let activityViewController = UIActivityViewController(activityItems: shareObject,
                                                                  applicationActivities: nil)
            present(activityViewController, animated: true)
//            DispatchQueue.main.async { [weak self] in
//
//            }

        }.disposed(by: disposeBag)
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
        descriptionView.descriptionButton.rx.tap.bind { [weak self] in
            if let desctiption = self?.viewModel.book.description {
                self?.pushTextVC(text: desctiption)
            }
        }.disposed(by: disposeBag)
    }
    private func setUI() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareButton)
        view.addSubview(stackView)
        [headerView, linkView, descriptionView].forEach { stackView.addArrangedSubview($0) }
        
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
    private func pushTextVC(text: String) {
        let textVC = TextViewController(text: text)
        navigationController?.pushViewController(textVC, animated: true)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
