//
//  TableShowCode.swift
//  MayberAdminNew
//
//  Created by Airtemium on 24.05.2021.
//

import Foundation
import UIKit
import Lottie

protocol TableShowCodeDelegate
{
    func tableShowCodeDelegateOKAction(_ sender: TableShowCode?)
    
    func tableShowCodeDelegateCreateAction(_ sender: TableShowCode?)
    
    func TableShowCodeDelegateObtainCode(tableUid: String, finish: @escaping (_ code: Int) -> ())
}

class TableShowCode: UIView
{
    private var _tableUid = ""
    
    var tableUid: String { _tableUid }
    
    var delegate: TableShowCodeDelegate?
    
    var animationView: AnimationView!
    
    var GetTableUID: String
    {
        get
        {
            return tableUid
        }
    }
    
    var bg: UIView = {
        var b = UIView()
        b.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return b
    }()
    
    var layout: UIView = {
        var l = UIView()
        l.backgroundColor = UIColor.white
        l.layer.cornerRadius = 17
        l.layer.masksToBounds = true
        return l
    }()
    
    var code: UILabel = {
        var l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 100)
        l.textColor = .black
        l.numberOfLines = 0
        l.sizeToFit()
        return l
    }()

    var buttonOK: UIButton = {
        var b = UIButton()
        b.backgroundColor = UIColor.white
        b.layer.cornerRadius = 14
        b.setTitle("OK", for: .normal)
        b.setTitleColor(.black, for: .normal)
        return b
    }()
    
    var buttonCreate: UIButton = {
        var b = UIButton()
        b.backgroundColor = UIColor.white
        b.layer.cornerRadius = 14
        b.setTitle("Create order", for: .normal)
        b.setTitleColor(.black, for: .normal)
        return b
    }()
    
    var separatorActions1: UIView = {
        var r = UIView()
        r.backgroundColor = UIColor(red: 229/255, green: 230/255, blue: 234/255, alpha: 1)
        return r
    }()
    
    var separatorActions2: UIView = {
        var r = UIView()
        r.backgroundColor = UIColor(red: 229/255, green: 230/255, blue: 234/255, alpha: 1)
        return r
    }()
    
    var title: UILabel = {
        var l = UILabel()
        l.textColor = .black
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.sizeToFit()
        return l
    }()
    
    var subtitle: UILabel = {
        var l = UILabel()
        l.textColor = .black
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = UIColor(red: 93/255, green: 93/255, blue: 93/255, alpha: 1)
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.sizeToFit()
        return l
    }()
    
    init(tableUid: String)
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        _tableUid = tableUid
        
        self.addSubview(bg)
        self.addSubview(layout)
        layout.addSubview(code)
        layout.addSubview(buttonCreate)
        layout.addSubview(buttonOK)
        layout.addSubview(separatorActions1)
        layout.addSubview(separatorActions2)
        
        layout.addSubview(title)
        layout.addSubview(subtitle)
        
        
        bg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        layout.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().inset(32)
            make.height.equalTo(ScreenSize.SCREEN_HEIGHT * 0.55)
        }
        
        code.snp.makeConstraints { make in
            make.width.equalTo(self.layout.snp.width)
            make.centerY.equalTo(self.layout.snp.centerY)
        }
        
        //---
        
        code.isHidden = true
        
        animationView = AnimationView()
        let animation = Animation.named("MayberLoaderBlack")
            
        animationView.animation = animation
        layout.addSubview(animationView)
        
        animationView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.center.equalToSuperview()
        }
        
        animationView.play()
        animationView.loopMode = .loop
        
        buttonCreate.isEnabled = false
        
        //----
        
        buttonOK.snp.makeConstraints { make in
            make.left.equalTo(layout.snp.left)
            make.right.equalTo(layout.snp.right)
            make.height.equalTo(56)
            make.bottom.equalTo(layout.snp.bottom)
        }
        
        buttonCreate.snp.makeConstraints { make in
            make.left.equalTo(layout.snp.left)
            make.right.equalTo(layout.snp.right)
            make.height.equalTo(56)
            make.bottom.equalTo(buttonOK.snp.top)
        }
        
        separatorActions1.snp.makeConstraints { make in
            make.left.equalTo(layout.snp.left)
            make.right.equalTo(layout.snp.right)
            make.height.equalTo(1)
            make.top.equalTo(buttonCreate.snp.top)
        }
        
        separatorActions2.snp.makeConstraints { make in
            make.left.equalTo(layout.snp.left)
            make.right.equalTo(layout.snp.right)
            make.height.equalTo(1)
            make.top.equalTo(buttonOK.snp.top)
        }
        
        //----
        
        title.snp.makeConstraints { make in
            make.left.equalTo(layout.snp.left).offset(24)
            make.right.equalTo(layout.snp.right).inset(24)
            make.top.equalTo(layout.snp.top).offset(36)
        }
        
        subtitle.snp.makeConstraints { make in
            make.left.equalTo(layout.snp.left).offset(24)
            make.right.equalTo(layout.snp.right).inset(24)
            make.top.equalTo(title.snp.bottom).offset(10)
        }
        
        title.text = "Booking code table"
        subtitle.text = "A guest may enter a table code on a restaurant screen in the \"Info\" section or on an order screen"
        
        //---

        buttonCreate.addAction {
            self.buttonCreateAction()
        }
        
        buttonOK.addAction {
            self.buttonOKAction()
        }

    }
    
    func Start()
    {
        self.delegate?.TableShowCodeDelegateObtainCode(tableUid: tableUid, finish: { code in
            self.animationView.stop()
            self.animationView.isHidden = true
            
            self.code.isHidden = false
            
            self.code.text = "\(code)"
            
            self.buttonCreate.isEnabled = true
        })
    }

    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonCreateAction()
    {
        delegate?.tableShowCodeDelegateCreateAction(self)
    }

    func buttonOKAction()
    {
        delegate?.tableShowCodeDelegateOKAction(self)
    }
}
