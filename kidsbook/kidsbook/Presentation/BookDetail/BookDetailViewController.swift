//
//  BookDetailViewController.swift
//  kidsbook
//
//  Created by paytalab on 8/10/24.
//

import UIKit

class BookDetailViewController: UIViewController {
    private let viewModel: BookDetailViewModelProtocol
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 3

        return label
    }()
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return label
    }()
    private let bookTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return label
    }()
   
    private let bookImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let borderView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
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
        
    }
    private func setUI() {
        view.backgroundColor = .white
        [titleLabel, authorLabel, bookTypeLabel, bookImage, borderView].forEach {
            view.addSubview($0)
        }
        titleLabel.text = viewModel.book.title
        authorLabel.text = viewModel.book.authors.reduce("", { result, author in
            result.isEmpty ? author : result + ", " + author
        })
        bookTypeLabel.text = "eBook * \(viewModel.book.pageCount)페이지"
        if let thumbnail = viewModel.book.thumbnail {
            bookImage.setImage(urlString: thumbnail)
        }
        setConstraints()
    }
    
    private func setConstraints() {
        bookImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(16)
            make.width.equalTo(100)
            make.height.equalTo(140)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bookImage)
            make.leading.equalTo(bookImage.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
        }
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalTo(titleLabel)
        }
        bookTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom)
            make.leading.trailing.equalTo(titleLabel)
        }
        borderView.snp.makeConstraints { make in
            make.top.equalTo(bookImage.snp.bottom).offset(20)
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
