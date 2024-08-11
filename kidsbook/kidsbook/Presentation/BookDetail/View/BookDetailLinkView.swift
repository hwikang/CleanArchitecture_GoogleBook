//
//  BookDetailLinkView.swift
//  kidsbook
//
//  Created by paytalab on 8/11/24.
//

import UIKit

final class BookDetailLinkView: UIView {
    private let hasSample: Bool
    
    private let buttonStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()

    public let sampleButton = {
        let button = UIButton()
        button.setTitle("샘플 읽기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 4
        return button
    }()
    public let buyLinkButton = {
        let button = UIButton()
        button.setTitle("사러 가기", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        return button
    }()
    private let infoImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "info.circle"))
        imageView.tintColor = .gray
        return imageView
    }()
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.numberOfLines = 2
        label.text = "Google Play 웹사이트에서 구매한 책을 이 앱에서 읽을 수 있습니다."
        label.textColor = .gray
        return label
    }()

    private let borderView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    init(hasSample: Bool) {
        self.hasSample = hasSample
        super.init(frame: .zero)
        setUI()
    }
    
    private func setUI() {
        [buttonStackView, infoImageView, infoLabel, borderView].forEach { addSubview($0) }
        
        if hasSample {
            buttonStackView.addArrangedSubview(sampleButton)
        }
        buttonStackView.addArrangedSubview(buyLinkButton)

        setConstraints()
    }
    
    private func setConstraints() {
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        infoImageView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(12)
            make.leading.equalTo(16)
            make.width.height.equalTo(16)
        }
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(infoImageView)
            make.leading.equalTo(infoImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
        }
        borderView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
