//
//  EmptyResultTableViewCell.swift
//  kidsbook
//
//  Created by paytalab on 8/11/24.
//

import UIKit

final class EmptyResultTableViewCell: UITableViewCell, BookListCellType {

    static let identifier = "EmptyResultTableViewCell"
    private let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "Google Play 검색결과"
        return label
    }()
    
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
    }
    func apply(cellData: BookListCellData) {
        guard case let .empty(filter) = cellData else { return }
        titleLabel.text = "\(filter.title) 검색결과 없음"
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
