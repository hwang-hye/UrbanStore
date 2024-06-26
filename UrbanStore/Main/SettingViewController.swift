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
        
        let totalLikeCount = UserDefaults.standard.integer(forKey: "totalLikeCount")
        cartLabel.text = "\(totalLikeCount)개의 상품"
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLikeCount(_:)), name: .totalLikeCountUpdated, object: nil)

    }
    
    @objc func updateLikeCount(_ notification: Notification) {
            if let totalLikeCount = notification.userInfo?["totalLikeCount"] as? Int {
                cartLabel.text = "\(totalLikeCount)개의 상품"
            }
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self, name: .totalLikeCountUpdated, object: nil)
        }


    
    override func viewDidAppear(_ animated: Bool) {
        configure()
        loadProfileImage()
        navigationItem.title = "SETTINGS"
    }
    
    func loadProfileImage() {
        if let imageName = UserDefaults.standard.string(forKey: "selectProfileImage"),
           let image = UIImage(named: imageName) {
            profileImageChangeButton.setImage(image, for: .normal)
        }
    }
    
    func configure() {
        view.backgroundColor = .white
        
        profileImageChangeButton.backgroundColor = .white
        profileImageChangeButton.layer.borderWidth = 6
        profileImageChangeButton.layer.cornerRadius = 40
        profileImageChangeButton.layer.borderColor = UIColor.accent.cgColor
        profileImageChangeButton.contentMode = .scaleAspectFill
        profileImageChangeButton.setImage(UIImage(named: "profile_0"), for: .normal)
        profileImageChangeButton.addTarget(self, action: #selector(profileImageChangeButtonClicked), for: .touchUpInside)
        
        profileImageChangeButton.imageView?.contentMode = .scaleAspectFill
        profileImageChangeButton.clipsToBounds = true
        
        nicknameChangeButton.setTitleColor(.black, for: .normal)
        nicknameChangeButton.setTitleColor(.sub, for: .highlighted)
        nicknameChangeButton.setTitle("Guest", for: .normal)
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
        arrowImageView.tintColor = .sub
        arrowImageView.contentMode = .scaleAspectFill
        
        cartLabel.textColor = .darkGray
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
    
    func showDeleteAccountAlert(for indexPath: IndexPath) {
        let alertController = UIAlertController(title: "탈퇴하기", message: "정말로 탈퇴하시겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: { _ in
            self.tableView.deselectRow(at: indexPath, animated: true)
        })
        let confirmAction = UIAlertAction(title: "확인", style: .destructive, handler: { _ in
            
            let domain = Bundle.main.bundleIdentifier! // 현재 앱의 bundle identifier 가져오기
            UserDefaults.standard.removePersistentDomain(forName: domain) // 해당 bundle identifier에 저장된 모든 UserDefaults 데이터 제거
            UserDefaults.standard.synchronize()
            
            let windowScene =  UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            let rootViewController = UINavigationController(rootViewController: SignViewController())
            
            sceneDelegate?.window?.rootViewController = rootViewController
            sceneDelegate?.window?.makeKeyAndVisible()
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
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
        let option = SettingOptions.allCases[indexPath.row]
        cell.textLabel?.text = option.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = SettingOptions.allCases[indexPath.row]
        if option == .deleteAccount {
            showDeleteAccountAlert(for: indexPath)
        }
    }
}
