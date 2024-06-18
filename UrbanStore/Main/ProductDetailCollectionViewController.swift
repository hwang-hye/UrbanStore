//
//  ProductDetailCollectionViewController.swift
//  UrbanStore
//
//  Created by hwanghye on 6/18/24.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit
import WebKit


// Item 구조체 정의
struct Item: Codable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
}

// NaverAPIResponse 구조체 정의
struct NaverAPIResponse: Codable {
    let items: [Item]
}

class ProductDetailCollectionViewController: UIViewController {
    
    var items: [Item] = []
    let searchBar = UISearchBar()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 20
        let cellSpacing: CGFloat = 20
        let width = UIScreen.main.bounds.width - (sectionSpacing * 2) - cellSpacing
        layout.itemSize = CGSize(width: width/2, height: width/1.4)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        configure()
        configureLayout()
        
        searchBar.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductDetailCollectionViewCell.self, forCellWithReuseIdentifier: ProductDetailCollectionViewCell.identifier)
    }
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let query = searchBar.text, !query.isEmpty {
            loadItems(query: query)
        }
    }
    
    func loadItems(query: String) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(encodedQuery)"
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.id,
            "X-Naver-Client-Secret": APIKey.Secret]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: NaverAPIResponse.self) { response in
            switch response.result {
            case .success(let result):
                self.items = result.items
                self.collectionView.reloadData()
            case .failure(let error):
                print("Failed to load items: \(error)")
            }
        }
    }
    
    
    func configure() {
        view.backgroundColor = .white
        navigationItem.title = "검색결과"
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        
        searchBar.placeholder = "브랜드, 상품 등을 입력하세요"
    }
    
    func configureLayout() {
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}


extension ProductDetailCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailCollectionViewCell.identifier, for: indexPath) as! ProductDetailCollectionViewCell
        let item = items[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        let productDetailVC = ProductDetailViewController()
        productDetailVC.link = item.link
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}
