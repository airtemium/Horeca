//
//  OrderstopPanel.swift
//  MayberAdminNew
//
//  Created by Artem on 19.05.2021.
//

import Foundation
import UIKit

protocol OrdersTopPanelDelegate
{
    func OrdersTopPanelDelegateSwitchToMap()
    
    func OrdersTopPanelDelegateSwitchToProfile()
}

class OrdersTopPanel: UIView
{
    var delegate: OrdersTopPanelDelegate?

    var buttonMap: UIButton = {
        var b = UIButton()
        return b
    }()
    
    var buttonProfile: UIButton = {
        var b = UIButton()
        return b
    }()
    
    var iconMap: UIImageView = {
        var b = UIImageView()
        b.image = UIImage(named: "orders_map")
        return b
    }()
    
    var iconProfile: UIImageView = {
        var b = UIImageView()
        b.image = UIImage(named: "orders_profile")
        return b
    }()
    
    var orderTitle: UILabel = {
        var l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 18)
        l.textColor = .black
        return l
    }()
    
    var orderCountTitle: UILabel = {
        var l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 18)
        l.textColor = .black
        return l
    }()
    
    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.backgroundColor = .white
        
        self.addSubview(iconMap)
            
        self.addSubview(iconProfile)
        
        self.addSubview(buttonProfile)
            
        self.addSubview(buttonMap)
        
        self.addSubview(orderTitle)
        
        self.addSubview(orderCountTitle)
        
        iconMap.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(self.snp.left).offset(16)
            make.bottom.equalTo(self.snp.bottom).inset(20)
        }
        
        iconProfile.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalTo(self.snp.right).inset(16)
            make.bottom.equalTo(self.snp.bottom).inset(20)
        }
        
        //---
        
        buttonMap.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(24 + 16 + 15)
        }
        
        buttonProfile.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(24 + 16 + 15)
        }
        
        //---
        
        orderCountTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom).inset(5)
        }
        
        orderTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(orderCountTitle.snp.top)
        }
        
        buttonMap.addTarget(self, action: #selector(self.buttonMapAction(_:)), for: .touchUpInside)
    
        
        buttonProfile.addTarget(self, action: #selector(self.openProfile(_:)), for: .touchUpInside)
    }
    
    @objc func openProfile(_ sender: AnyObject)
    {
        guard let d = self.delegate else {
            return
        }
        
        d.OrdersTopPanelDelegateSwitchToProfile()
    }
    
    @objc func buttonMapAction(_ sender: AnyObject)
    {
        guard let d = self.delegate else {
            return
        }
        
        d.OrdersTopPanelDelegateSwitchToMap()
    }
    
    func Update(orderCount: Int, amount: Double, currency: String)
    {
        orderCountTitle.text = PriceWithCurrencyFormatter(price: amount, currency: currency)
        orderTitle.text = "Orders: \(orderCount)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
