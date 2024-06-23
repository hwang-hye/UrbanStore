//
//  MainViewController.swift
//  UrbanStore
//
//  Created by hwanghye on 6/17/24.
//

import UIKit
import SnapKit

struct SearchResult {
    var title: String
    let iconImage: UIImage
    let deleteButton: UIButton
}

class MainViewController: UIViewController {
    let searchBar = UISearchBar()
    
    let emptyView = UIView()
    let emptyImageView = UIImageView()
    let emptyLable = UILabel()
    
    let mainView = UIView()
    let mainLabel = UILabel()
    let mainDeleteAllLabel = UILabel()
    let searchResult: [SearchResult] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureLayout()
        
        if let lastSearchQuery = UserDefaults.lastSearchQuery {
            searchBar.text = lastSearchQuery
        }

    }
    
    func configure() {
        view.backgroundColor = .white
        
        searchBar.delegate = self
        searchBar.placeholder = "브랜드, 상품 등을 입력하세요"
        
        emptyImageView.image = UIImage(named: "empty")
        emptyImageView.contentMode = .scaleAspectFill
        
        emptyLable.text = "최근 검색어가 없어요"
        emptyLable.font = .systemFont(ofSize: 16, weight: .bold)
        emptyLable.textAlignment = .center
    }
    
    func configureLayout() {
        view.addSubview(searchBar)
        view.addSubview(emptyView)
        emptyView.addSubview(emptyImageView)
        emptyView.addSubview(emptyLable)
        view.addSubview(mainView)

        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.centerX.equalTo(emptyView)
            make.centerY.equalTo(emptyView).offset(-50)
            make.width.height.equalTo(200)
        }
       
        emptyLable.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(emptyView.safeAreaLayoutGuide).inset(30)
            make.height.height.equalTo(22)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, !query.isEmpty {
            UserDefaults.lastSearchQuery = query
            
            let productVC = ProductDetailCollectionViewController()
            navigationController?.pushViewController(productVC, animated: true)
        }
    }

}

extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension UserDefaults {
    static var lastSearchQuery: String? {
        get { return UserDefaults.standard.string(forKey: "lastSearchQuery") }
        set { UserDefaults.standard.set(newValue, forKey: "lastSearchQuery") }
    }
}
