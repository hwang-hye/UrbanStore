//
//  ProfileImgCollectionViewCell.swift
//  UrbanStore
//
//  Created by hwanghye on 6/15/24.
//

import UIKit
import SnapKit

class ProfileImgCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ProfileImgCollectionViewCell"
    
    let profileImageView = UIImageView()
    let profileImageButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        configure()
        configureLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        profileImageView.backgroundColor = .black
        profileImageView.layer.cornerRadius = frame.size.width / 2
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        
        profileImageButton.backgroundColor = .white
        profileImageButton.layer.cornerRadius = (frame.size.width - 8) / 2
        profileImageButton.setImage(UIImage(named: "profile_0"), for: .normal)
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        profileImageButton.clipsToBounds = true
    }
    
    
    
    func configureLayout() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(profileImageButton)
        
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImageButton.snp.makeConstraints { make in
            make.edges.equalTo(profileImageView.snp.edges).inset(4)
        }
    }
}
