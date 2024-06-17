//
//  ProductDetailCollectionViewCell.swift
//  UrbanStore
//
//  Created by hwanghye on 6/18/24.
//

import UIKit
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
        productImage.layer.cornerRadius = 10
        productShop.text = "shopname"
        productShop.font = .systemFont(ofSize: 12, weight: .regular)
        productShop.textColor = .gray
        productTitle.text = "키보드 키캡 레오폴드"
        productTitle.font = .systemFont(ofSize: 14, weight: .semibold)
        productPrice.text = "105,000원"
        productPrice.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    
    func configureLayout() {
        contentView.addSubview(productImage)
        contentView.addSubview(productShop)
        contentView.addSubview(productTitle)
        contentView.addSubview(productPrice)
        
        productImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(180)
            
        }
        productShop.snp.makeConstraints { make in
            make.top.equalTo(productImage.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(16)
        }
        
        productTitle.snp.makeConstraints { make in
            make.top.equalTo(productShop.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(18)
        }
        
        productPrice.snp.makeConstraints { make in
            make.top.equalTo(productTitle.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(20)
        }
        
    }
}
