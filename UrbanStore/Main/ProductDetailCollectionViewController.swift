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
    var totalLikeCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: "totalLikeCount")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "totalLikeCount")
            NotificationCenter.default.post(name: .totalLikeCountUpdated, object: nil, userInfo: ["totalLikeCount": newValue])
        }
    }
    let searchBar = UISearchBar()
    let resultView = UIView()
    let searchResultLabel = UILabel()
    let accuracyButton = UIButton()
    let dateButton = UIButton()
    let highPriceButton = UIButton()
    let lowPriceButton = UIButton()
    let nickname = UserDefaults.standard.string(forKey: "nicknameText")
    var currentPage = 1
    var totalPageCount = 1
    let itemsPerPage = 30
    var isLoading = false
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTotalLikes(_:)), name: .likeButtonTapped, object: nil)
        
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
        
        if let lastSearchQuery = UserDefaults.lastSearchQuery {
                searchBar.text = lastSearchQuery
            }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.title = "\(nickname ?? "") URBAN STORE"
        searchBar.becomeFirstResponder() // 검색바에 포커스 주기

    }
    
    @objc func updateTotalLikes(_ notification: Notification) {
        if let isLiked = notification.userInfo?["isLiked"] as? Bool {
            totalLikeCount += isLiked ? 1 : -1
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .likeButtonTapped, object: nil)
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
            UserDefaults.lastSearchQuery = query
            currentPage = 1
            loadItems(query: query, page: currentPage)
        }
        navigationItem.title = searchBar.text
    }
    
    func loadItems(query: String, page: Int) {
        guard !isLoading else { return }
            isLoading = true
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let displayCount = 100 // 네이버API 요청 최대 갯수
        let start = (page - 1) * itemsPerPage + 1
        let url = "\(APIURL.shopItemURL)\(encodedQuery)&display=\(itemsPerPage)&start=\(start)"
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.id,
            "X-Naver-Client-Secret": APIKey.Secret]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: NaverAPIResponse.self) { response in
            self.isLoading = false
            switch response.result {
            case .success(let result):
                if page == 1 {
                    self.items = result.items
                } else {
                    self.items.append(contentsOf: result.items)
                }
                
                self.filteredItems = self.items
                self.searchResultLabel.text = "\(result.total)개의 검색결과"
                self.totalPageCount = (result.total + self.itemsPerPage - 1) / self.itemsPerPage
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

extension ProductDetailCollectionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight * 2, !isLoading, currentPage < totalPageCount {
            currentPage += 1
            if let query = searchBar.text, !query.isEmpty {
                loadItems(query: query, page: currentPage)
            }
        }
    }
}


extension Notification.Name {
    static let likeButtonTapped = Notification.Name("likeButtonTapped")
    static let totalLikeCountUpdated = Notification.Name("totalLikeCountUpdated")
}

