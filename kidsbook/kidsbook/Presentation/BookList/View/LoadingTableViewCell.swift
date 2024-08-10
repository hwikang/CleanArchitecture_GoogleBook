//
//  LoadingTableViewCell.swift
//  kidsbook
//
//  Created by paytalab on 8/10/24.
//

import UIKit

final class LoadingTableViewCell: UITableViewCell, BookListCellType {

    static let identifier = "LoadingTableViewCell"
    private let indicatorView = UIActivityIndicatorView(style: .medium)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indicatorView.stopAnimating()
    }
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
    func apply(cellData: BookListCellData) {
        indicatorView.startAnimating()
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
