//
//  SeatsTopPanel.swift
//  MayberAdminNew
//
//  Created by Airtemium on 29.05.2021.
//

import Foundation
import UIKit

protocol SeatsTopPanelDelegate
{
    func SeatsTopPanelDelegateBackAction()
    
    func SeatsTopPanelDelegateOrdersAction()
}

class SeatsTopPanel: UIView
{
    private var _badgeCount = 0
    
    var badgeSize: CGFloat = 20
    
    var delegate: SeatsTopPanelDelegate?
    
    var buttonMap: UIButton = {
        var b = UIButton()
//        b.backgroundColor = .red
        return b
    }()
    
    var buttonBack: UIButton = {
        
        var b = UIButton()
//        b.backgroundColor = .red
        return b
    }()
    
    var iconMap: UIImageView = {
        var b = UIImageView()
        b.image = UIImage(named: "button_orders_white")
        return b
    }()
    
    var iconBack: UIImageView = {
        var b = UIImageView()
        b.image = UIImage(named: "button_back_white")
        return b
    }()
    
    var SeatsTitle: UILabel = {
        var l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 18)
        l.textColor = UIColor(red: 255/255, green: 207/255, blue: 0/255, alpha: 1) // 255 207 0
        return l
    }()
    
    var SeatsSubtitle: UILabel = {
        var l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 18)
        l.textColor = .white
        return l
    }()
    
    var badge: UIView = {
        var v = UIView()
        v.isHidden = true
        v.backgroundColor = .red
        return v
    }()
    
    var badgeLabel: UILabel = {
        var l = UILabel()
        l.textAlignment = .center
        l.textColor = .white
        l.font = UIFont.systemFont(ofSize: 12)
        return l
    }()
    
    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.backgroundColor = .black
        
        self.addSubview(iconMap)
            
        self.addSubview(iconBack)
        
        self.addSubview(buttonMap)
            
        self.addSubview(buttonBack)
        
        self.addSubview(SeatsSubtitle)
        
        self.addSubview(SeatsTitle)
        
        self.addSubview(badge)
        
        badge.addSubview(badgeLabel)
        
        iconBack.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(self.snp.left).offset(16)
            make.bottom.equalTo(self.snp.bottom).inset(20)
        }
        
        iconMap.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalTo(self.snp.right).inset(16)
            make.bottom.equalTo(self.snp.bottom).inset(20)
        }
        
        //---
        
        buttonBack.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(24 + 16 + 15)
        }
        
        buttonMap.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(24 + 16 + 15)
        }
        
        //---
        
        badge.snp.makeConstraints { make in
            make.width.height.equalTo(badgeSize)
            
            make.bottom.equalTo(iconMap.snp.top).offset(10)
            make.left.equalTo(iconMap.snp.right).offset(-10)
        }
        
        badgeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        badge.layer.cornerRadius = badgeSize / 2
        
        //---
        
        SeatsSubtitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom).inset(5)
            
        }
        
        SeatsTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(SeatsSubtitle.snp.top)
        }
        
        buttonBack.addTarget(self, action: #selector(self.buttonBackAction(_:)), for: .touchUpInside)
        buttonMap.addTarget(self, action: #selector(self.buttonMapAction(_:)), for: .touchUpInside)
    
    }
    
    @objc func buttonBackAction(_ sender: UIButton)
    {
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.SeatsTopPanelDelegateBackAction()
    }
    
    @objc func buttonMapAction(_ sender: UIButton)
    {
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.SeatsTopPanelDelegateOrdersAction()
    }
    
    func Update(tableName: String, amount: Double, currency: String, code: String)
    {
        SeatsTitle.text = "\(tableName) (Code: \(code))"
//        orderCountTitle.text = "\(currency)\(amount)"
//        SeatsSubtitle.text = PriceWithCurrencyFormatter(price: amount, currency: currency)
    }
    
    func UpdateAmount(amount: Double, currency: String)
    {
        SeatsSubtitle.text = PriceWithCurrencyFormatter(price: amount, currency: currency)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var BadgeCount: Int
    {
        get
        {
            return _badgeCount
        }
    }
    
    
    func SetBadgeCount(count: Int)
    {
        _badgeCount = count
         
        if(_badgeCount > 0)
        {
            self.badge.isHidden = false
            
            self.badgeLabel.text = "\(_badgeCount)"
        }
        else
        {
            self.badge.isHidden = true
        }
    }
}
