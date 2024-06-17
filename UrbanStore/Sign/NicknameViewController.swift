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
    
    // 시간차로? 뜨는? 와이?
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.title = "PROFILE SETTING"
    }
    

    func configure() {
        view.backgroundColor = .white
        navigationItem.title = "PROFILE SETTING" // 다음 페이지 다녀오면 사라지는 이슈?
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        
        profileImageView.backgroundColor = .white
        profileImageView.image = UIImage(named: "profile_\(Int.random(in: 0...11))")
        profileImageView.layer.borderWidth = 6
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        
        nicknameTextField.placeholder = "닉네임을 입력해주세요"
        nicknameTextField.borderStyle = .none
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        
        nicknameTextFieldBorder.backgroundColor = .black
            
        nicknameTextLabel.text = ""
        nicknameTextLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
        nicknameButton.setTitle("완료", for: .normal)
        nicknameButton.setTitleColor(.white, for: .normal)
        nicknameButton.setTitleColor(.gray, for: .highlighted)
        nicknameButton.layer.backgroundColor = UIColor.black.cgColor
        nicknameButton.layer.cornerRadius = 22
        nicknameButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        nicknameButton.addTarget(self, action: #selector(nicknameButtonClicked), for: .touchUpInside)
    }
    
    
    @objc func textFieldDidChange() {
        let nickname = nicknameTextField.text!
        
        if !nicknameValidationCount(nickname: nickname) {
            nicknameTextLabel.text = "2글자 이상 10글자 미만으로 설정해주세요"
            nicknameTextLabel.textColor = .red
            return
        }
        
        if !nicknameValidationChar(nickname: nickname) {
            nicknameTextLabel.text = "닉네임에 @, #, $, % 는 사용할 수 없어요"
            nicknameTextLabel.textColor = .red
            return
        }
        
        if !nicknameValidationNotNumber(nickname: nickname) {
            nicknameTextLabel.text = "닉네임에 숫자는 포함할 수 없어요"
            nicknameTextLabel.textColor = .red
            return
        }
        
        nicknameTextLabel.text = "사용할 수 있는 닉네임이에요"
        nicknameTextLabel.textColor = .blue
    }
    
    func nicknameValidationCount(nickname: String) -> Bool {
        
        switch nickname.count {
        case 0..<2: false
        case 10...: false
            
        default:
            true
        }
    }


    func nicknameValidationChar(nickname: String) -> Bool {
        let specialCharacter = ["@", "#", "$", "%"]
        
        for char in specialCharacter {
            if nickname.contains(char) {
                return false
            }
        }
        return true
    }


    func nicknameValidationNotNumber(nickname: String) -> Bool {
        let range = nickname.rangeOfCharacter(from: CharacterSet.decimalDigits)
        
        if range != nil {
            return false // "숫자가 있다"
        } else {
            return true // "숫자가 없다"
        }
    }
    
    @objc func nicknameButtonClicked() {
        guard let text = nicknameTextField.text else { return }
        UserDefaults.standard.set(text, forKey: "nicknameText")
        
        let isRootTabBar = self.view.window?.rootViewController is TabBarController
        
        if !isRootTabBar {
            navigationController?.pushViewController(ProfileImgCollectionViewController(), animated: true)
        } else {
            navigationController?.popViewController(animated: true)
            // self.view.window?.rootViewController = TabBarController()
            // self.view.window?.makeKeyAndVisible()
        }
    }
    
    
    func configureLayout() {
        view.addSubview(profileImageView)
        view.addSubview(nicknameTextField)
        view.addSubview(nicknameTextFieldBorder)
        view.addSubview(nicknameTextLabel)
        view.addSubview(nicknameButton)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalTo(view)
            make.width.height.equalTo(100)
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
    
    func profileImageViewRadius() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageViewRadius()
    }
}


