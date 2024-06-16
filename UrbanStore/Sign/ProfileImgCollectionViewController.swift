//
//  ProfileImgCollectionViewController.swift
//  UrbanStore
//
//  Created by hwanghye on 6/14/24.
//

import UIKit
import SnapKit


class ProfileImgCollectionViewController: UIViewController {
    
    var profileImages: [UIImage] = []
    let profileImageView = UIImageView()

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 20
        let cellSpacing: CGFloat = 10
        let width = UIScreen.main.bounds.width - (sectionSpacing * 2) - (cellSpacing * 3)
        layout.itemSize = CGSize(width: width/4, height: width/4)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        
        return layout
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        loadImages()
        configure()
        configureLayout()
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileImgCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImgCollectionViewCell.identifier)
    }
    

    func loadImages() {
        // Asset에서 이미지를 로드하여 배열에 저장
        let n = 13
        for i in 0..<n {
            if let image = UIImage(named: "profile_\(i)") {
                profileImages.append(image)
            }
        }
    }
    
    
    func configure() {
        view.backgroundColor = .white
        title = "PROFILE SETTING"
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        
        profileImageView.backgroundColor = .white
        profileImageView.image = UIImage(named: "profile_0")
        profileImageView.layer.borderWidth = 6
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
    }
    
    
    func configureLayout() {
        
        view.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalTo(view)
            make.width.height.equalTo(100)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func profileImageViewRadius() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageViewRadius()
    }
}


extension ProfileImgCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImgCollectionViewCell.identifier, for: indexPath) as! ProfileImgCollectionViewCell
        
        cell.profileImageButton.setImage(profileImages[indexPath.item], for: .normal)

        return cell
    }
}
