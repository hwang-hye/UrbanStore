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
    
    var isSelectedCell = false {
        didSet {
            profileImageView.backgroundColor = isSelectedCell ? .accent : .sub
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        configureLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(restoreColor), name: Notification.Name("restoreColor"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configure() {
        profileImageView.backgroundColor = .sub
        profileImageView.layer.cornerRadius = frame.size.width / 2
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.alpha = 0.5
        
        profileImageButton.backgroundColor = .white
        profileImageButton.layer.cornerRadius = (frame.size.width - 8) / 2
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        profileImageButton.clipsToBounds = true
        profileImageButton.addTarget(self, action: #selector(profileImageButtonClicked(_:)), for: .touchUpInside)
    }
    
    @objc func profileImageButtonClicked(_ sender: UIButton) {
        isSelectedCell = true
        NotificationCenter.default.post(name: Notification.Name("restoreColor"), object: self)
    }
    
    @objc func restoreColor(_ notification: Notification) {
        guard let senderCell = notification.object as? ProfileImgCollectionViewCell else {
            return
        }
        if senderCell != self {
            isSelectedCell = false
        }
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
