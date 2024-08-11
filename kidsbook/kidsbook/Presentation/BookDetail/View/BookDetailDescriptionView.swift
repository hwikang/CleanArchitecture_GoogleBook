//
//  BookDetailDescriptionView.swift
//  kidsbook
//
//  Created by paytalab on 8/11/24.
//

import UIKit

final public class BookDetailDescriptionView: UIView {
    private let descriptionString: String?
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    public let descriptionButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        return button
    }()
    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 4
        return label
    }()
    
    
    init(descriptionString: String?) {
        self.descriptionString = descriptionString
        super.init(frame: .zero)
        setUI()
    }
    private func setUI() {

        [titleLabel, descriptionButton, descLabel].forEach {  addSubview($0)  }
        titleLabel.text = "eBook 정보"
        if let descriptionString = descriptionString {
            descLabel.text = descriptionString
        } else {
            self.isHidden = true
        }
        setConstraints()
    }
    
    private func setConstraints() {

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.leading.equalTo(16)
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        descriptionButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(16)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
