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
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        view.addSubview(webView)
        view.backgroundColor = .white
        
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        if let productDetailURL = link,
           let url = URL(string: productDetailURL) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
