//
//  MainViewController.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

final class  ProfileViewController: BaseViewController
{
    //orders_map
    
    var profilePanel: UIView = {
        var p = UIView()
        p.backgroundColor = UIColor.black.withAlphaComponent(0.09)
        return p
    }()
    
    var buttonOrdersAction: UIButton = {
        var b = UIButton()
//        b.backgroundColor = .red
        return b
    }()
    
    var buttonBackAction: UIButton = {
        var b = UIButton()
//        b.backgroundColor = .red
        return b
    }()
    
    var buttonOrders: UIImageView = {
        var b = UIImageView()
        b.image = UIImage(named: "button_orders_black")
        return b
    }()
    
    
    var buttonBack: UIImageView = {
        var b = UIImageView()
        b.image = UIImage(named: "orders_map")
        return b
    }()
    
    var avatar: UIImageView = {
        var i = UIImageView()
        i.layer.cornerRadius = 86 / 2
        i.clipsToBounds = true
        i.image = UIImage(named: "settings_avatar_empty")
        return i
    }()
    
    var username: UILabel = {
        var l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 34)
        l.text = ""
        l.textColor = .black
        l.numberOfLines = 0
        l.sizeToFit()
        return l
    }()
    
    var usernameTitle: UILabel = {
        var l = UILabel()
        l.text = "name"
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 12)        
        l.textColor = UIColor.black.withAlphaComponent(0.37)
        l.numberOfLines = 0
        l.sizeToFit()
        return l
    }()
    
    var buttonLogout: UIButton = {
        var b = UIButton()
        b.setTitle("LOG OUT", for: .normal)
        b.setTitleColor(.red, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return b
    }()
    
    // MARK: - Public properties -
    var presenter: ProfilePresenterProtocol!

    // MARK: - Lifecycle -
    override func viewDidLoad()
    {
//        Logger.log("\(type(of: self))")
        
        super.viewDidLoad()
        
        setupView()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        username.text = self.presenter.getFullName()
    }

    // MARK: - Constraints -
    override func updateViewConstraints()
    {
        if (!didSetupConstraints)
        {       
            profilePanel.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.left.equalTo(self.view.snp.left)
                make.right.equalTo(self.view.snp.right)
                make.top.equalTo(self.view.snp.top)
                make.height.equalTo(ScreenSize.SCREEN_HEIGHT / 3)
            }
            
            buttonBack.snp.makeConstraints { make in
                make.width.height.equalTo(24)
//                make.left.equalTo(self.view.snp.left).offset(16)
                make.right.equalTo(self.view.snp.right).offset(-16)
                make.top.equalTo(self.view.snp.top).offset(54)
            }
            
            buttonBackAction.snp.makeConstraints { make in
                make.width.equalTo(24 + 16 + 15)
                make.height.equalTo(98)
//                make.left.equalTo(self.view.snp.left)
                make.right.equalTo(self.view.snp.right)
                make.top.equalTo(self.view.snp.top).offset(10)
            }
            
            buttonOrders.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.left.equalTo(self.view.snp.left).offset(16)
//                make.right.equalTo(self.view.snp.right).offset(-16)
                make.top.equalTo(self.view.snp.top).offset(54)
            }
            
            buttonOrdersAction.snp.makeConstraints { make in
                make.width.equalTo(24 + 16 + 15)
                make.height.equalTo(98)
                make.left.equalTo(self.view.snp.left)
//                make.right.equalTo(self.view.snp.right)
                make.top.equalTo(self.view.snp.top).offset(10)
            }
            
            avatar.snp.makeConstraints { make in
                make.width.height.equalTo(ScreenSize.SCREEN_HEIGHT / 4)
                make.centerX.equalTo(profilePanel)
                make.bottom.equalTo(profilePanel.snp.bottom).offset(-24)
            }
            
            //---
            
            usernameTitle.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16)
                make.top.equalTo(profilePanel.snp.bottom).offset(36)
            }
            
            username.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16)
                make.top.equalTo(usernameTitle.snp.bottom)
            }
            
            buttonLogout.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-106)
            }
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

    // MARK: - Methdos -
    func setupView()
    {
        view.setNeedsUpdateConstraints()

        self.view.backgroundColor = UIColor.white
        
        
        self.view.addSubview(profilePanel)
        profilePanel.addSubview(buttonBack)
        profilePanel.addSubview(buttonOrders)
        profilePanel.addSubview(buttonBackAction)
        profilePanel.addSubview(buttonOrdersAction)
        profilePanel.addSubview(avatar)
        
        self.view.addSubview(usernameTitle)
        self.view.addSubview(username)
        self.view.addSubview(buttonLogout)
        
        buttonBackAction.isEnabled = true
        buttonBackAction.addAction {
            self.actionBack()
        }

        buttonOrdersAction.addAction {
            self.actionToOrders()
        }
        
        buttonLogout.addAction {
            self.actionLogout()
        }
    }
    
    func actionToOrders()
    {
        print("*** actionToOrders")
        self.presenter.GoToOrders()
    }
    
    func actionLogout()
    {
        NotificationCenter.default.post(name: Constants.Notify.UserUidRemove, object: nil)
        
        self.presenter.Logout()
    }
    
    func actionBack()
    {
        print("*** actionBack")
        self.presenter.GoBack()
    }
}

// MARK: - Extensions -
extension ProfileViewController: ProfileViewProtocol
{

}

