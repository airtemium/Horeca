//
//  CommonAlert.swift
//  MayberAdminNew
//
//  Created by Artem on 29.06.2021.
//

import Foundation
import UIKit

class CommonAlert: UIView
{
    var bg: UIView = {
        var b = UIView()
        b.alpha = 1
        b.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return b
    }()
    
    var layoutBG: UIImageView = {
        var i = UIImageView()
        i.image = UIImage(named: "common_alert_bg")
        return i
    }()
    
    var layout: UIView = {
        var l = UIView()
        l.clipsToBounds = true
        l.layer.cornerRadius = 10
        return l
    }()
    
    var icon: UIImageView = {
        var i = UIImageView()
        i.image = UIImage(named: "common_alert_onfo")
        return i
    }()
    
    var title: UILabel = {
        var t = UILabel()
        t.font = UIFont.boldSystemFont(ofSize: 20)
        t.textAlignment = .center
        t.textColor = .white
        t.lineBreakMode = .byWordWrapping
        t.numberOfLines = 0
        t.sizeToFit()
        return t
    }()
    
    var subtitle: UILabel = {
        var t = UILabel()
        t.font = UIFont.systemFont(ofSize: 15)
        t.textAlignment = .center
        t.textColor = .white
        t.lineBreakMode = .byWordWrapping
        t.numberOfLines = 0
        t.sizeToFit()
        return t
    }()
    
    var button: UIButton = {
        var b = UIButton()
        b.setTitle("OK", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        b.setTitleColor(.white, for: .normal)
        return b
    }()
    
    var sep: UIView = {
        var b = UIView()
        b.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return b
    }()

    init(actionOK: @escaping () -> ())
    {
        super.init(frame: .zero)

        self.addSubview(bg)
        self.addSubview(layout)
        layout.addSubview(layoutBG)
        layout.addSubview(icon)
        
        layout.addSubview(title)
        layout.addSubview(subtitle)
        layout.addSubview(button)
        layout.addSubview(sep)
        
        
        bg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        layout.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.top.equalToSuperview().offset(200)
            make.height.equalTo(375)
        }
        
        layoutBG.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.top.equalToSuperview().offset(64)
            make.centerX.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        subtitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(64)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        sep.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalToSuperview()
            make.bottom.equalTo(button.snp.top)
        }
        
        title.text = "Unable to delete the table"
        subtitle.text = "There is a valid check-in.\nTo delete the table\nclose the check-in first."
        
        button.addAction {
            actionOK()
            
            self.snp.removeConstraints()
            self.removeFromSuperview()
        }
    }
    
    @objc func ok(_ sender: AnyObject)
    {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
