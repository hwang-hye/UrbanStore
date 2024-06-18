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
    let profileImageSelectButton = UIButton()

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
        
        loadProfileImages()
        configure()
        configureLayout()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileImgCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImgCollectionViewCell.identifier)
        
        selectProfileImage()
    }
    
    func saveImage(named imageName: String) {
        UserDefaults.standard.set(imageName, forKey: "selectProfileImage")
    }
    
    func selectProfileImage() {
        if let imageName = UserDefaults.standard.string(forKey: "selectProfileImage"),
           let image = UIImage(named: imageName) {
            profileImageView.image = image
        }
    }
    
    func loadProfileImages() {
        let n = 13
        for i in 0..<n {
            if let image = UIImage(named: "profile_\(i)") {
                profileImages.append(image)
            }
        }
    }
    
    func configure() {
        view.backgroundColor = .white
        navigationItem.title = "PROFILE SETTING"
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        
        profileImageView.backgroundColor = .white
        profileImageView.image = UIImage(named: "profile_\(Int.random(in: 0...11))")
        profileImageView.layer.borderWidth = 6
        profileImageView.layer.borderColor = UIColor.accent.cgColor
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        
        profileImageSelectButton.setTitle("선택", for: .normal)
        profileImageSelectButton.setTitleColor(.white, for: .normal)
        profileImageSelectButton.setTitleColor(.gray, for: .highlighted)
        profileImageSelectButton.layer.backgroundColor = UIColor.accent.cgColor
        profileImageSelectButton.layer.cornerRadius = 22
        profileImageSelectButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        profileImageSelectButton.addTarget(self, action: #selector(profileImageSelectButtonClicked), for: .touchUpInside)
    }
    
    @objc func profileImageSelectButtonClicked() {
        let isRootTabBar = self.view.window?.rootViewController is TabBarController
        
        if !isRootTabBar {
            self.view.window?.rootViewController = TabBarController()
            self.view.window?.makeKeyAndVisible()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func configureLayout() {
        view.addSubview(profileImageView)
        view.addSubview(profileImageSelectButton)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalTo(view)
            make.width.height.equalTo(100)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            // collectionView가 가진 사이즈만큼
            // height 설정하는 법?
            make.height.equalTo(300)
        }
        profileImageSelectButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(collectionView.snp.bottom)
            make.height.equalTo(44)
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
        
        let image = profileImages[indexPath.item]
        cell.profileImageButton.setImage(image, for: .normal)
        cell.profileImageButton.tag = indexPath.item
        cell.profileImageButton.addTarget(self, action: #selector(profileImageButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    @objc func profileImageButtonClicked(_ sender: UIButton) {
        let imageName = "profile_\(sender.tag)"// profileImages[sender.tag]
        profileImageView.image = sender.image(for: .normal)
        saveImage(named: imageName)
    }
}

