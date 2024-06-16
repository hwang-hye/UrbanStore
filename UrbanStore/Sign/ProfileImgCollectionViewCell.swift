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
        profileImageButton.addTarget(self, action: #selector(profileImageClicked), for: .touchUpInside)

    }
    
    
    @objc func profileImageClicked() {
        print("Button Clicked")
        // select된 profileImageButton의 image
        // NotificationCenter 전송
        NotificationCenter.default.post(name: .cellButtonClicked, object: profileImageButton.image(for: .selected))
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


extension Notification.Name {
    static let cellButtonClicked = Notification.Name("cellButtonClicked")
}
