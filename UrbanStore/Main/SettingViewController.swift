//
//  SettingViewController.swift
//  UrbanStore
//
//  Created by hwanghye on 6/17/24.
//

import UIKit
import SnapKit

enum SettingOptions: String, CaseIterable {
    case cart = "나의 장바구니 목록"
    case faq = "자주 묻는 질문"
    case inquiry = "1:1 문의"
    case notification = "알림 설정"
    case deleteAccount = "탈퇴하기"
}


class SettingViewController: UIViewController {
    
    let profileSettingView = UIView()
    let profileImageChangeButton = UIButton()
    let nicknameChangeButton = UIButton()
    let signUpDateLabel = UILabel()
    let arrowImageView = UIImageView()
    let cartLabel = UILabel()
    
    let tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        configureLayout()
        loadProfileImage()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    }

    
    func loadProfileImage() {
        if let imageName = UserDefaults.standard.string(forKey: "selectProfileImage"),
           let image = UIImage(named: imageName) {
            profileImageChangeButton.setImage(image, for: .normal)
        }
    }
    
    
    func configure() {
        view.backgroundColor = .white
//        title = "SETTING" 
//        navigationController?.navigationBar.topItem?.title = ""
//        navigationController?.navigationBar.tintColor = .black
        

        profileImageChangeButton.backgroundColor = .white
        profileImageChangeButton.layer.borderWidth = 6
        profileImageChangeButton.layer.cornerRadius = 40
        profileImageChangeButton.layer.borderColor = UIColor.black.cgColor
        profileImageChangeButton.contentMode = .scaleAspectFill
        profileImageChangeButton.setImage(UIImage(named: "profile_0"), for: .normal)
        profileImageChangeButton.addTarget(self, action: #selector(profileImageChangeButtonClicked), for: .touchUpInside)
        
        profileImageChangeButton.imageView?.contentMode = .scaleAspectFill
        profileImageChangeButton.clipsToBounds = true
        
        nicknameChangeButton.setTitleColor(.black, for: .normal)
        nicknameChangeButton.setTitleColor(.darkGray, for: .highlighted)
        nicknameChangeButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        nicknameChangeButton.titleLabel?.numberOfLines = 0
        if let nicknameText = UserDefaults.standard.string(forKey: "nicknameText") {
            nicknameChangeButton.setTitle(nicknameText, for: .normal)
        }
        nicknameChangeButton.addTarget(self, action: #selector(nicknameChangeButtonClicked), for: .touchUpInside)
        
        signUpDateLabel.text = "2024-06-01 가입"
        signUpDateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        signUpDateLabel.textColor = .darkGray
        
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = .darkGray
        arrowImageView.contentMode = .scaleAspectFill
        
        cartLabel.text = "n개의 상품"
        cartLabel.font = .systemFont(ofSize: 12, weight: .bold)
        
        
    }
    
    @objc func profileImageChangeButtonClicked() {
        navigationController?.pushViewController(ProfileImgCollectionViewController(), animated: true)
    }
    

    @objc func nicknameChangeButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }
    
    
    func configureLayout() {
        view.addSubview(profileSettingView)
        view.addSubview(tableView)
        view.addSubview(cartLabel)
        profileSettingView.addSubview(profileImageChangeButton)
        profileSettingView.addSubview(nicknameChangeButton)
        profileSettingView.addSubview(signUpDateLabel)
        profileSettingView.addSubview(arrowImageView)
        
        profileSettingView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        
        profileImageChangeButton.snp.makeConstraints { make in
            make.top.leading.equalTo(profileSettingView.safeAreaLayoutGuide).offset(10)
            make.width.height.equalTo(80)
        }
        
        nicknameChangeButton.snp.makeConstraints { make in
            make.top.equalTo(profileSettingView.snp.top).inset(26)
            make.leading.equalTo(profileImageChangeButton.snp.trailing).offset(10)
            make.height.equalTo(24)
        }
        
        signUpDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageChangeButton.snp.trailing).offset(10)
            make.top.equalTo(nicknameChangeButton.snp.bottom).offset(1)
            make.height.equalTo(18)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalTo(profileSettingView.snp.trailing).inset(10)
            make.centerY.equalTo(profileSettingView.safeAreaLayoutGuide)
            make.width.height.equalTo(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileSettingView.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        cartLabel.snp.makeConstraints { make in
            make.top.equalTo(profileSettingView.snp.bottom).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(18)
        }
    }
}


extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = SettingOptions.allCases[indexPath.row].rawValue
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        return cell
    }
}
