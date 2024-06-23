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
    
    let productImage = UIImageView()
    let productShop = UILabel()
    let productTitle = UILabel()
    let productPrice = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
    
    func configureLayout() {
        contentView.addSubview(productImage)
        contentView.addSubview(productShop)
        contentView.addSubview(productTitle)
        contentView.addSubview(productPrice)
        
        productImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(180)
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
