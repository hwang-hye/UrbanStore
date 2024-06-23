//
//  ProductDetailCollectionViewCell.swift
//  UrbanStore
//
//  Created by hwanghye on 6/18/24.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit

class ProductDetailCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProductDetailCollectionViewCell"
    
    let productImageView = UIView()
    let productImage = UIImageView()
    let productLikeButton = UIButton()
    var isLiked = false
    let productShop = UILabel()
    let productTitle = UILabel()
    let productPrice = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureLayout()
        
        productLikeButton.addTarget(self, action: #selector(productLikeButtonClicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func productLikeButtonClicked() {
        isLiked.toggle()
        NotificationCenter.default.post(name: .likeButtonTapped, object: nil, userInfo: ["isLiked": isLiked])
        updateLikeButtonUI()
    }
    
    func updateLikeButtonUI() {
        let likeButtonImage = isLiked ? "handbag.fill" : "handbag"
        productLikeButton.setImage(UIImage(systemName: likeButtonImage), for: .normal)
    }
    
    func configure() {
        productImage.backgroundColor = .black
        productImage.layer.cornerRadius = 14
        productImage.clipsToBounds = true
        productShop.text = "shopname"
        productShop.font = .systemFont(ofSize: 12, weight: .regular)
        productShop.textColor = .gray
        productTitle.text = "productTitle"
        productTitle.font = .systemFont(ofSize: 14, weight: .semibold)
        productTitle.numberOfLines = 2
        productPrice.text = "price원"
        productPrice.font = .systemFont(ofSize: 16, weight: .bold)
        productLikeButton.backgroundColor = .white
        productLikeButton.layer.cornerRadius = 6
        productLikeButton.setImage(UIImage(systemName: "handbag"), for: .normal)
        productLikeButton.tintColor = .black
    }
    
    func configureLayout() {
        contentView.addSubview(productImageView)
        productImageView.addSubview(productImage)
        productImageView.addSubview(productLikeButton)
        contentView.addSubview(productShop)
        contentView.addSubview(productTitle)
        contentView.addSubview(productPrice)
      
        productImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(180)
        }
        productImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(180)
        }
        productLikeButton.snp.makeConstraints { make in
            make.bottom.equalTo(productImageView.safeAreaLayoutGuide).inset(10)
            make.trailing.equalTo(productImageView.safeAreaLayoutGuide).inset(10)
            make.width.height.equalTo(30)
        }
        productShop.snp.makeConstraints { make in
            make.top.equalTo(productImage.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(16)
        }
        
        productTitle.snp.makeConstraints { make in
            make.top.equalTo(productShop.snp.bottom).offset(2)
            make.horizontalEdges.equalToSuperview()
        }
        productPrice.snp.makeConstraints { make in
            make.top.equalTo(productTitle.snp.bottom).offset(2)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    func configure(with item: Item) {
        productShop.text = item.mallName
        productTitle.text = item.title
        productPrice.text = "\(item.lprice)원"
        if let itemImageURL = URL(string: item.image) {
            productImage.kf.setImage(with: itemImageURL)
        }
    }
}
