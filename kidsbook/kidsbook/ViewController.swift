//
//  ViewController.swift
//  kidsbook
//
//  Created by paytalab on 8/9/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let session = BookURLSession()

        let bookNetwork = BookNetwork(network: NetworkManager(session: session))
        Task {
            let result = await bookNetwork.searchBooks(query: "ios", filter: .freeEbook, pageIndex: 1)
            print(result)
        }
    }


}

