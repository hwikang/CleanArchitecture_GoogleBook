//
//  BookDetailViewController.swift
//  kidsbook
//
//  Created by paytalab on 8/10/24.
//

import UIKit

class BookDetailViewController: UIViewController {
    private let viewModel: BookDetailViewModelProtocol
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
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
