//
//  NicknameViewController.swift
//  UrbanStore
//
//  Created by hwanghye on 6/14/24.
//

import UIKit
import SnapKit

class NicknameViewController: UIViewController {
    
    let profileImageView = UIImageView()
    let profileImageButton = UIButton()
    
    // 이 아래 요소들을 하나의 view로 묶어
    // 다음 페이지에서 갈아끼울 수는 없을까?
    let nicknameTextField = UITextField()
    let nicknameTextFieldBorder = UIView()
    let nicknameTextLabel = UILabel()
    let nicknameButton = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        configureLayout()
    }
    

    func configure() {
        view.backgroundColor = .white
        title = "PROFILE SETTING" // 다음 페이지 다녀오면 사라지는 이슈?
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        
        profileImageView.backgroundColor = .black
        profileImageView.layer.cornerRadius = 50
        
        profileImageButton.backgroundColor = .white
        let profileImageViewDiameter = 100 - 16
        profileImageButton.layer.cornerRadius = CGFloat(profileImageViewDiameter / 2)
        profileImageButton.setImage(UIImage(named: "profile_0"), for: .normal)
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        profileImageButton.clipsToBounds = true
        
        nicknameTextField.placeholder = "닉네임을 입력해주세요"
        nicknameTextField.borderStyle = .none
        
        nicknameTextFieldBorder.backgroundColor = .black
            
        nicknameTextLabel.text = "닉네임에 @는 포함할 수 없어요"
        nicknameTextLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
        nicknameButton.setTitle("완료", for: .normal)
        nicknameButton.setTitleColor(.white, for: .normal)
        nicknameButton.setTitleColor(.gray, for: .highlighted)
        nicknameButton.layer.backgroundColor = UIColor.black.cgColor
        nicknameButton.layer.cornerRadius = 22
        nicknameButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        nicknameButton.addTarget(self, action: #selector(nicknameButtonClicked), for: .touchUpInside)
    }
    
    
    @objc func nicknameButtonClicked() {
        navigationController?.pushViewController(ProfileImgCollectionViewController(), animated: true)
    }
    
    
    func configureLayout() {
        view.addSubview(profileImageView)
        view.addSubview(profileImageButton)
        view.addSubview(nicknameTextField)
        view.addSubview(nicknameTextFieldBorder)
        view.addSubview(nicknameTextLabel)
        view.addSubview(nicknameButton)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalTo(view)
            make.width.height.equalTo(100)
        }
        profileImageButton.snp.makeConstraints { make in
            make.edges.equalTo(profileImageView.snp.edges).inset(8)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        
        nicknameTextFieldBorder.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(6)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(1)
        }
        
        nicknameTextLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextFieldBorder.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(22)
        }
        
        nicknameButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(44)
        }
    }
}
