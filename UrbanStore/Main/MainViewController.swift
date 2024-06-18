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
        
//        if hasSearchHistory() {
//            showMainUI()
//        } else {
//            showEmptyUI()
//        }
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
    
    func hasSearchHistory() -> Bool {
        return UserDefaults.standard.string(forKey: "lastSearchQuery") != nil
    }
    
//    func showMainUI() {
//        emptyView.isHidden = true
//        mainView.isHidden = false
//    }
//    
//    func showEmptyUI() {
//        emptyView.isHidden = false
//        mainView.isHidden = true
//    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        UserDefaults.standard.set(searchText, forKey: "lastSearchQuery")
        searchBar.resignFirstResponder()
//        showMainUI()
    }
}
