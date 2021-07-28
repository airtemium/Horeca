//
//  SeatsConfirmAlerrt.swift
//  MayberAdminNew
//
//  Created by Artem on 30.06.2021.
//

import Foundation
import UIKit

class SeatsConfirmAlert: UIView
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
    
    var buttonCancel: UIButton = {
        var b = UIButton()
        b.setTitle("Cancel", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        b.setTitleColor(.white, for: .normal)
        return b
    }()
    
    var buttonContinue: UIButton = {
        var b = UIButton()
        b.setTitle("Continue without confirm", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        b.setTitleColor(.white, for: .normal)
        return b
    }()
    
    var sep: UIView = {
        var b = UIView()
        b.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return b
    }()
    
    var sep2: UIView = {
        var b = UIView()
        b.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return b
    }()

    init(actionCancel: @escaping () -> (), actionContinue: @escaping () -> ())
    {
        super.init(frame: .zero)

        self.addSubview(bg)
        self.addSubview(layout)
        layout.addSubview(layoutBG)
        layout.addSubview(icon)
        
        layout.addSubview(title)
        layout.addSubview(subtitle)
        layout.addSubview(buttonCancel)
        layout.addSubview(sep)
        layout.addSubview(buttonContinue)
        layout.addSubview(sep2)
        
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
        
        buttonCancel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(58)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        sep.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalToSuperview()
            make.bottom.equalTo(buttonCancel.snp.top)
        }
        
        buttonContinue.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(58)
            make.left.equalToSuperview()
            make.bottom.equalTo(buttonCancel.snp.top)
        }
        
        sep2.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalToSuperview()
            make.bottom.equalTo(buttonContinue.snp.top)
        }
        
        title.text = "Unconfirmed order\nchanges will not be saved"
        subtitle.text = "You can save changes\non the order details screen"
        
        buttonCancel.addAction {
            actionCancel()
            
            self.snp.removeConstraints()
            self.removeFromSuperview()
        }
        
        buttonContinue.addAction {
            actionContinue()
            
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
