//
//  SignViewController.swift
//  UrbanStore
//
//  Created by hwanghye on 6/14/24.
//

import UIKit
import SnapKit

class SignViewController: UIViewController {
    let titleLabel = UILabel()
    let titleImageView = UIImageView()
    var startButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureLayout()
        
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }
    
    @objc func startButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }
    
    func configure() {
        titleLabel.text = "URBAN STORE"
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .accent
        
        titleImageView.image = UIImage(named: "launch")
        titleImageView.contentMode = .scaleAspectFill
        
        startButton.setTitle("시작하기", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.setTitleColor(.gray, for: .highlighted)
        startButton.layer.backgroundColor = UIColor.accent.cgColor
        startButton.layer.cornerRadius = 22
        startButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    func configureLayout() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(titleImageView)
        view.addSubview(startButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(44)
        }
        titleImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(300)
        }
        // starButton bottom Setting 후 전체 레이아웃 위치 달라지는 이유?
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(44)
        }
    }
}
