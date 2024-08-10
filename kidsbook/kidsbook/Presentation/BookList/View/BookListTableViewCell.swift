//
//  BookListTableViewCell.swift
//  kidsbook
//
//  Created by paytalab on 8/10/24.
//

import UIKit

class BookListTableViewCell : UITableViewCell, BookListCellType {
 
    static let identifier = "BookListTableViewCell"
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2

        return label
    }()
    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return label
    }()
    let bookTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return label
    }()
   
    let bookImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    func apply(cellData: BookListCellData) {
        guard case let .book(book, bookType) = cellData else { return }
        titleLabel.text = book.title
        authorLabel.text = book.authors.reduce("", { result, author in
            result.isEmpty ? author : result + ", " + author
        })
        bookTypeLabel.text = bookType.rawValue
        if let thumbnail = book.thumbnail {
            bookImage.setImage(urlString: thumbnail)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bookImage.image = UIImage(named: "placeholder")
    }
    
    private func setUI() {

        [titleLabel, authorLabel, bookTypeLabel, bookImage].forEach {
            contentView.addSubview($0)
        }
        bookImage.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.leading.bottom.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(140)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bookImage)
            make.leading.equalTo(bookImage.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
        }
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalTo(titleLabel)
        }
        bookTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom)
            make.leading.trailing.equalTo(titleLabel)
        }

    }
      
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
      
}
