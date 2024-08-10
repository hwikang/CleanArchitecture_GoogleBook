//
//  TitleTableViewCell.swift
//  kidsbook
//
//  Created by paytalab on 8/10/24.
//

import UIKit

final class TitleTableViewCell: UITableViewCell, BookListCellType {

    static let identifier = "TitleTableViewCell"
    private let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "Google Play 검색결과"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUI()
    }
    
    private func setUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
    }
    
    func apply(cellData: BookListCellData) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
