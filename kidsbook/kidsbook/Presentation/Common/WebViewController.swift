//
//  WebViewController.swift
//  kidsbook
//
//  Created by paytalab on 8/11/24.
//

import UIKit
import RxSwift
import WebKit

public class WebViewController: UIViewController {
    private let url: String
   
    private let disposeBag = DisposeBag()
    
    private lazy var webView = {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        let webview = WKWebView(frame: .zero, configuration: config)
        return webview
    }()
    
    public init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let link = url.replacingOccurrences(of: "http://", with: "https://")
        if let url = URL(string: link) {
            webView.load(URLRequest(url: url))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
