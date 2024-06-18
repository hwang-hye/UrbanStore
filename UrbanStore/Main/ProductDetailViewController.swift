//
//  ProductDetailViewController.swift
//  UrbanStore
//
//  Created by hwanghye on 6/18/24.
//

import UIKit
import SnapKit
import WebKit

class ProductDetailViewController: UIViewController {
    
    var link: String?
    var navigationTitle: String?
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        view.addSubview(webView)
        view.backgroundColor = .white
        
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        if let productDetailURL = link,
           let url = URL(string: productDetailURL) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.title = "\(navigationTitle ?? "")"
    }
}
