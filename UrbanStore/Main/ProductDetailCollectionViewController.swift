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

struct Item: Codable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
}

struct NaverAPIResponse: Codable {
    let lastBuildDate: String
    let total: Int
    let items: [Item]
}

class ProductDetailCollectionViewController: UIViewController {
    var items: [Item] = []
    var filteredItems: [Item] = []
    let searchBar = UISearchBar()
    let resultView = UIView()
    let searchResultLabel = UILabel()
    let accuracyButton = UIButton()
    let dateButton = UIButton()
    let highPriceButton = UIButton()
    let lowPriceButton = UIButton()
    let nickname = UserDefaults.standard.string(forKey: "nicknameText")
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 20
        let cellSpacing: CGFloat = 20
        let width = UIScreen.main.bounds.width - (sectionSpacing * 2) - cellSpacing
        layout.itemSize = CGSize(width: width/2, height: width/1.4)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = cellSpacing
        layout.minimumLineSpacing = 30
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
        
        accuracyButton.addTarget(self, action: #selector(accuracyButtonClicked), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(dateButtonClicked), for: .touchUpInside)
        highPriceButton.addTarget(self, action: #selector(highPriceButtonClicked), for: .touchUpInside)
        lowPriceButton.addTarget(self, action: #selector(lowPriceButtonClicked), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.title = "\(nickname ?? "") URBAN STORE"
    }
    
    @objc func accuracyButtonClicked() {
        resetButtonStyle()
        
        accuracyButton.backgroundColor = .darkGray
        accuracyButton.setTitleColor(.white, for: .normal)
        accuracyButton.layer.borderColor = UIColor.white.cgColor

        filteredItems = items
        collectionView.reloadData()
    }
    
//    let dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        return formatter
//    }()
    
    @objc func dateButtonClicked() {
        resetButtonStyle()
        
        dateButton.backgroundColor = .darkGray
        dateButton.setTitleColor(.white, for: .normal)
        dateButton.layer.borderColor = UIColor.white.cgColor
//        filteredItems = items.sorted { (item1, item2) -> Bool in
//
//            if let date1 = dateFormatter.date(from: item1.lastBuildDate),
//               let date2 = dateFormatter.date(from: item2.lastBuildDate) {
//                return date1 > date2
//            }
//            return false
//        }
//        collectionView.reloadData()
    }
    
    @objc func highPriceButtonClicked() {
        resetButtonStyle()
        
        highPriceButton.backgroundColor = .darkGray
        highPriceButton.setTitleColor(.white, for: .normal)
        highPriceButton.layer.borderColor = UIColor.white.cgColor
        
        filteredItems = items.sorted { (item1, item2) -> Bool in
              if let price1 = Int(item1.lprice), let price2 = Int(item2.lprice) {
                  return price1 > price2
              }
              return false
          }
          collectionView.reloadData()
      }
    
    @objc func lowPriceButtonClicked() {
        resetButtonStyle()
        
        lowPriceButton.backgroundColor = .darkGray
        lowPriceButton.setTitleColor(.white, for: .normal)
        lowPriceButton.layer.borderColor = UIColor.white.cgColor
        
        filteredItems = items.sorted { (item1, item2) -> Bool in
            if let price1 = Int(item1.lprice), let price2 = Int(item2.lprice) {
                return price1 < price2
            }
            return false
        }
        collectionView.reloadData()
    }
    

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let query = searchBar.text, !query.isEmpty {
            loadItems(query: query)
        }
    }
    
    func loadItems(query: String) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = "\(APIURL.shopItemURL)\(encodedQuery)"
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.id,
            "X-Naver-Client-Secret": APIKey.Secret]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: NaverAPIResponse.self) { response in
            switch response.result {
            case .success(let result):
                self.items = result.items
                self.filteredItems = self.items
                let total = result.total
                self.searchResultLabel.text = "\(total)개의 검색결과"
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
        resultView.backgroundColor = .white
        searchResultLabel.font = .systemFont(ofSize: 14, weight: .bold)
        searchResultLabel.textColor = .accent
        
        accuracyButton.setTitle(" 정확도 ", for: .normal)
        accuracyButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        accuracyButton.setTitleColor(UIColor.black, for: .normal)
        accuracyButton.layer.borderWidth = 0.8
        accuracyButton.layer.cornerRadius = 8

        dateButton.setTitle(" 날짜순 ", for: .normal)
        dateButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        dateButton.setTitleColor(UIColor.black, for: .normal)
        dateButton.layer.borderWidth = 0.8
        dateButton.layer.cornerRadius = 8

        highPriceButton.setTitle(" 가격높은순 ", for: .normal)
        highPriceButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        highPriceButton.setTitleColor(UIColor.black, for: .normal)
        highPriceButton.layer.borderWidth = 0.8
        highPriceButton.layer.cornerRadius = 8

        lowPriceButton.setTitle(" 가격낮은순 ", for: .normal)
        lowPriceButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        lowPriceButton.setTitleColor(UIColor.black, for: .normal)
        lowPriceButton.layer.borderWidth = 0.8
        lowPriceButton.layer.cornerRadius = 8

    }
    
    func resetButtonStyle() {
        accuracyButton.setTitleColor(UIColor.black, for: .normal)
        accuracyButton.backgroundColor = .clear
        accuracyButton.layer.borderColor = UIColor.black.cgColor
        dateButton.setTitleColor(UIColor.black, for: .normal)
        dateButton.backgroundColor = .clear
        dateButton.layer.borderColor = UIColor.black.cgColor
        highPriceButton.setTitleColor(UIColor.black, for: .normal)
        highPriceButton.backgroundColor = .clear
        highPriceButton.layer.borderColor = UIColor.black.cgColor
        lowPriceButton.setTitleColor(UIColor.black, for: .normal)
        lowPriceButton.backgroundColor = .clear
        lowPriceButton.layer.borderColor = UIColor.black.cgColor
    }
    
    func configureLayout() {
        view.addSubview(searchBar)
        view.addSubview(resultView)
        resultView.addSubview(searchResultLabel)
        resultView.addSubview(accuracyButton)
        resultView.addSubview(dateButton)
        resultView.addSubview(highPriceButton)
        resultView.addSubview(lowPriceButton)
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        resultView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(70)
        }
        searchResultLabel.snp.makeConstraints { make in
            make.top.equalTo(resultView.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(resultView.safeAreaLayoutGuide).inset(20)
        }
        accuracyButton.snp.makeConstraints { make in
            make.top.equalTo(searchResultLabel.snp.bottom).offset(10)
            make.leading.equalTo(resultView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(24)
        }
        dateButton.snp.makeConstraints { make in
            make.top.equalTo(searchResultLabel.snp.bottom).offset(10)
            make.leading.equalTo(accuracyButton.snp.trailing).offset(6)
            make.height.equalTo(24)
        }
        highPriceButton.snp.makeConstraints { make in
            make.top.equalTo(searchResultLabel.snp.bottom).offset(10)
            make.leading.equalTo(dateButton.snp.trailing).offset(6)
            make.height.equalTo(24)
        }
        lowPriceButton.snp.makeConstraints { make in
            make.top.equalTo(searchResultLabel.snp.bottom).offset(10)
            make.leading.equalTo(highPriceButton.snp.trailing).offset(6)
            make.height.equalTo(24)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(resultView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}


extension ProductDetailCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailCollectionViewCell.identifier, for: indexPath) as! ProductDetailCollectionViewCell
        let item = filteredItems[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = filteredItems[indexPath.item]
        let productDetailVC = ProductDetailViewController()
        productDetailVC.link = item.link
        productDetailVC.navigationTitle = item.title
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}
