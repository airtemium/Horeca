//
//  MainViewController.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

final class  SettingsViewController: BaseViewController
{
    var topPanel: SettingsTopPanel = {
        var p = SettingsTopPanel()
        return p
    }()
    
    var bottomPanel: UIView = {
        var p = UIView()
        p.backgroundColor = .white
        return p
    }()
    
    var profilePanel: UIView = {
        var p = UIView()
        p.backgroundColor = UIColor.black.withAlphaComponent(0.09)
        return p
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
        l.font = UIFont.boldSystemFont(ofSize: 30)
        l.text = ""
        l.textColor = .black
        l.numberOfLines = 0
        l.sizeToFit()
        return l
    }()
    
    var usernameDescription: UILabel = {
        var l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 13)
        l.text = ""
        l.textColor = .black
        l.numberOfLines = 0
        l.sizeToFit()
        return l
    }()
    
    //---
    
    var teamPanel: UIView = {
        var p = UIView()
        p.backgroundColor = .white
        return p
    }()
    
    var tablesPanel: UIView = {
        var p = UIView()
        p.backgroundColor = .white
        return p
    }()
    
    var sep1: UIView = {
        var p = UIView()
        p.backgroundColor = UIColor.black.withAlphaComponent(0.09)
        return p
    }()
    
    var sep2: UIView = {
        var p = UIView()
        p.backgroundColor = UIColor.black.withAlphaComponent(0.09)
        return p
    }()
    
    //---
    
    var teamImage: UIImageView = {
        var i = UIImageView()
        i.image = UIImage(named: "settings_team")
        return i
    }()
    
    var tablesImage: UIImageView = {
        var i = UIImageView()
        i.image = UIImage(named: "settings_tables")
        return i
    }()
    
    var buttonProfile: UIButton = {
        var b = UIButton()
        return b
    }()
    
    var buttonTeam: UIButton = {
        var b = UIButton()
        return b
    }()
    
    var buttonTables: UIButton = {
        var b = UIButton()
        return b
    }()
    
    //---
    
    var titleTeam: UILabel = {
        var l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.text = "TEAM"
        l.textColor = .black
        l.numberOfLines = 0
        l.sizeToFit()
        return l
    }()
    
    var titleTables: UILabel = {
        var l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.text = "TABLES"
        l.textColor = .black
        l.numberOfLines = 0
        l.sizeToFit()
        return l
    }()
    
    // MARK: - Public properties -
    var presenter: SettingsPresenterProtocol!

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
        usernameDescription.text = self.presenter.getDescription()
    }

    // MARK: - Constraints -
    override func updateViewConstraints()
    {
        var blockHeight: CGFloat = (ScreenSize.SCREEN_HEIGHT - 98 - 85) / 3
        
        if (!didSetupConstraints)
        {
            topPanel.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.left.equalTo(self.view.snp.left)
                make.right.equalTo(self.view.snp.right)
                make.top.equalTo(self.view.snp.top)
                make.height.equalTo(98)
            }
            
            bottomPanel.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.left.equalTo(self.view.snp.left)
                make.right.equalTo(self.view.snp.right)
                make.bottom.equalTo(self.view.snp.bottom)
                make.height.equalTo(85)
            }
            
            profilePanel.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.left.equalTo(self.view.snp.left)
                make.right.equalTo(self.view.snp.right)
                make.top.equalTo(self.topPanel.snp.bottom)
                make.height.equalTo(blockHeight)
            }
            
            avatar.snp.makeConstraints { make in
                make.width.height.equalTo(86)
                make.centerX.equalTo(profilePanel)
                make.centerY.equalTo(profilePanel).offset(-30)
            }
            
            username.snp.makeConstraints { make in
                make.centerX.equalTo(profilePanel)
                make.top.equalTo(self.avatar.snp.bottom).offset(10)
            }
            
            usernameDescription.snp.makeConstraints { make in
                make.centerX.equalTo(profilePanel)
                make.top.equalTo(self.username.snp.bottom).offset(10)
            }
            
            buttonTables.snp.makeConstraints { make in
                make.edges.equalTo(profilePanel)
            }
            
            //---
            
            teamPanel.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.left.equalTo(self.view.snp.left)
                make.right.equalTo(self.view.snp.right)
                make.top.equalTo(self.profilePanel.snp.bottom)
                make.height.equalTo(blockHeight)
            }
            
            tablesPanel.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.left.equalTo(self.view.snp.left)
                make.right.equalTo(self.view.snp.right)
                make.top.equalTo(self.teamPanel.snp.bottom)
                make.height.equalTo(blockHeight)
            }
            
            //----
            
            sep1.snp.makeConstraints { make in
                make.left.equalTo(self.view.snp.left).offset(26)
                make.right.equalTo(self.view.snp.right)
                make.bottom.equalTo(self.teamPanel.snp.bottom)
                make.height.equalTo(1)
            }
            
            teamImage.snp.makeConstraints { make in
                make.width.equalTo(84)
                make.height.equalTo(60)
                make.center.equalTo(teamPanel)
            }
            
            titleTeam.snp.makeConstraints { make in
                make.centerX.equalTo(teamPanel)
                make.top.equalTo(self.teamImage.snp.bottom).offset(12)
            }
            
            buttonTeam.snp.makeConstraints { make in
                make.edges.equalTo(teamPanel)
            }
            
            //----
            
            sep2.snp.makeConstraints { make in
                make.left.equalTo(self.view.snp.left).offset(26)
                make.right.equalTo(self.view.snp.right)
                make.bottom.equalTo(self.tablesPanel.snp.bottom)
                make.height.equalTo(1)
            }
            
            tablesImage.snp.makeConstraints { make in
                make.width.equalTo(84)
                make.height.equalTo(60)
                make.center.equalTo(tablesPanel)
            }
            
            titleTables.snp.makeConstraints { make in
                make.centerX.equalTo(tablesPanel)
                make.top.equalTo(self.tablesImage.snp.bottom).offset(12)
            }
            
            buttonTables.snp.makeConstraints { make in
                make.edges.equalTo(tablesPanel)
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
        
        self.view.addSubview(topPanel)
        self.view.addSubview(bottomPanel)
        
        self.view.addSubview(profilePanel)
        profilePanel.addSubview(avatar)
        profilePanel.addSubview(username)
        profilePanel.addSubview(usernameDescription)
        profilePanel.addSubview(buttonProfile)
        
        //---
        
        self.view.addSubview(teamPanel)
        self.view.addSubview(tablesPanel)
        
        teamPanel.addSubview(sep1)
        teamPanel.addSubview(teamImage)
        teamPanel.addSubview(titleTeam)
        teamPanel.addSubview(buttonTeam)
        
        tablesPanel.addSubview(sep2)
        tablesPanel.addSubview(tablesImage)
        tablesPanel.addSubview(titleTables)
        tablesPanel.addSubview(buttonTables)
        
        topPanel.delegate = self
        
        buttonTeam.addTarget(self, action: #selector(self.buttonTeamAction(_:)), for: .touchUpInside)
        buttonTables.addTarget(self, action: #selector(self.buttonTablesAction(_:)), for: .touchUpInside)
        buttonProfile.addTarget(self, action: #selector(self.buttonProfileAction(_:)), for: .touchUpInside)
    }
    
    @objc func buttonProfileAction(_ sender: AnyObject)
    {
        self.presenter.GoToProfile()
    }
    
    @objc func buttonTeamAction(_ sender: AnyObject)
    {
        
    }
    
    @objc func buttonTablesAction(_ sender: AnyObject)
    {
        
    }

}

// MARK: - Extensions -
extension SettingsViewController: SettingsViewProtocol, SettingsTopPanelDelegate
{
    func SettingsTopPanelDelegateSwitchToMap()
    {
        self.presenter.switchToMap()
    }
    
    func SettingsTopPanelDelegateSwitchToOrders()
    {
        self.presenter.switchToOrders()
    }    
}

