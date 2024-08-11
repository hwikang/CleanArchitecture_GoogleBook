//
//  BookDetailHeaderView.swift
//  kidsbook
//
//  Created by paytalab on 8/11/24.
//

import UIKit

final class BookDetailHeaderView: UIView {
    private let book: BookListItem
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 3
        return label
    }()
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    private let bookTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
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
    
    init(book: BookListItem) {
        self.book = book
        super.init(frame: .zero)
        setUI()
    }
    
    private func setUI() {
        [titleLabel, authorLabel, bookTypeLabel, bookImage, borderView].forEach {
            addSubview($0)
        }
        titleLabel.text = book.title
        authorLabel.text = book.authors.reduce("", { result, author in
            result.isEmpty ? author : result + ", " + author
        })
        if let pageCount = book.pageCount {
            bookTypeLabel.text = "eBook * \(pageCount)페이지"

        } else {
            bookTypeLabel.text = "eBook"
        }
        if let thumbnail = book.thumbnail {
            bookImage.setImage(urlString: thumbnail)
        }
        setConstraints()
    }
    
    private func setConstraints() {

        bookImage.snp.makeConstraints { make in
            make.top.equalTo(10)
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
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
