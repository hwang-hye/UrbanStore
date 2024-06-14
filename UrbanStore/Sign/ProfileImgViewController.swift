//
//  ProfileImgViewController.swift
//  UrbanStore
//
//  Created by hwanghye on 6/14/24.
//

import UIKit

class ProfileImgViewController: UIViewController {
    
    let profileImageView = UIView()
    let profileImageButton = UIButton()
    
    let profileImgContainer = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureLayout()

    }
    

    func configure() {
        view.backgroundColor = .white
        title = "PROFILE SETTING"
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
    }
    
    
    func configureLayout() {
        
        
        
    }


}
