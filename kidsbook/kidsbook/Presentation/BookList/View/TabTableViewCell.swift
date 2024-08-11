//
//  TabTableViewCell.swift
//  kidsbook
//
//  Created by paytalab on 8/10/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class TabTableViewCell : UITableViewCell, BookListCellType {
 
    static let identifier = "TabTableViewCell"
    public let selectedTab = PublishRelay<BookSearchFilter>()
    public var disposeBag = DisposeBag()
    private let internalDisposeBag = DisposeBag()

    private let freeEbookTab: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(BookSearchFilter.freeEbook.title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.isSelected = true
        return button
    }()
    private let paidEbookTab: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(BookSearchFilter.paidEbook.title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.black, for: .selected)
        
        return button
    }()
    private let underBarView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()

    private let borderView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        freeEbookTab.rx.tap.bind { [weak self] in
            self?.selectedTab.accept(.freeEbook)
        }.disposed(by: internalDisposeBag)
        paidEbookTab.rx.tap.bind { [weak self] in
            self?.selectedTab.accept(.paidEbook)
        }.disposed(by: internalDisposeBag)
    }
    
    func apply(cellData: BookListCellData) {
        guard case let .tab(selectedFilter) = cellData else { return }
        switch selectedFilter {
        case .freeEbook:
            freeEbookTab.isSelected = true
            paidEbookTab.isSelected = false
            underBarView.snp.remakeConstraints { make in
                make.leading.equalTo(freeEbookTab)
                make.bottom.equalTo(freeEbookTab.snp.bottom)
                make.width.equalTo(freeEbookTab.snp.width)
                make.height.equalTo(2.5)
            }
            
        case .paidEbook:
            freeEbookTab.isSelected = false
            paidEbookTab.isSelected = true
            underBarView.snp.remakeConstraints { make in
                make.leading.equalTo(paidEbookTab)
                make.bottom.equalTo(freeEbookTab.snp.bottom)
                make.width.equalTo(freeEbookTab.snp.width)
                make.height.equalTo(2.5)
            }
            
        }
    }
    
    private func setUI() {
        [freeEbookTab, paidEbookTab, borderView, underBarView].forEach { contentView.addSubview($0) }
        freeEbookTab.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(48)
        }
        paidEbookTab.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(freeEbookTab.snp.trailing)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(48)
            make.width.equalTo(freeEbookTab.snp.width)
        }
        borderView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(freeEbookTab.snp.bottom)
            make.height.equalTo(1)
        }
        underBarView.snp.makeConstraints { make in
            make.leading.equalTo(freeEbookTab)
            make.bottom.equalTo(freeEbookTab.snp.bottom)
            make.width.equalTo(freeEbookTab.snp.width)
            make.height.equalTo(2.5)
        }

    }
      
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
      
}
