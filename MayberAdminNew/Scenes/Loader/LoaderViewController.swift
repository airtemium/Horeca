//
//  MainViewController.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import Alamofire
import AVKit
import AVFoundation

final class  LoaderViewController: BaseViewController
{
    // MARK: - Public properties -
    var presenter: LoaderPresenterProtocol!
    
    var logo: UIImageView = {
        var i = UIImageView()
        i.image = UIImage(named: "loader_icon")
        return i
    }()
    
    var titleLogo: UIImageView = {
        var i = UIImageView()
        i.image = UIImage(named: "loader_title")
        return i
    }()
    
    var subtitleLogo: UIImageView = {
        var i = UIImageView()
        i.image = UIImage(named: "loader_subtitle")
        return i
    }()

    // MARK: - Lifecycle -
    override func viewDidLoad()
    {
//        Logger.log("\(type(of: self))")
        
        super.viewDidLoad()
                        
        setupView()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.presenter.switchToMain()
        }
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true

    }

    // MARK: - Constraints -
    override func updateViewConstraints()
    {
        if (!didSetupConstraints)
        {
            logo.snp.makeConstraints { make in
                make.width.height.equalTo(160)
                make.centerX.centerY.equalToSuperview()
            }
            
            titleLogo.snp.makeConstraints { make in
                make.width.equalTo(logo.snp.width)
                make.height.equalTo(30)
                make.centerX.equalToSuperview()
                make.top.equalTo(self.logo.snp.bottom).offset(24)
            }
            
            subtitleLogo.snp.makeConstraints { make in
                make.width.equalTo(logo.snp.width)
                make.height.equalTo(34)
                make.centerX.equalToSuperview()
                make.top.equalTo(self.titleLogo.snp.bottom).offset(48)
            }

            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

    // MARK: - Methdos -
    func setupView()
    {
        view.setNeedsUpdateConstraints()

        self.view.backgroundColor = UIColor.black

        self.view.addSubview(logo)
        
        self.view.addSubview(titleLogo)
        
        self.view.addSubview(subtitleLogo)
    }

}

// MARK: - Extensions -
extension LoaderViewController: LoaderViewProtocol
{

}

