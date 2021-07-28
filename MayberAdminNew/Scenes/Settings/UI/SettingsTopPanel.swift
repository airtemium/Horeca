//
//  OrderstopPanel.swift
//  MayberAdminNew
//
//  Created by Artem on 19.05.2021.
//

import Foundation
import UIKit

protocol SettingsTopPanelDelegate
{
    func SettingsTopPanelDelegateSwitchToMap()
    func SettingsTopPanelDelegateSwitchToOrders()
}

class SettingsTopPanel: UIView
{
    var delegate: SettingsTopPanelDelegate?

    var buttonOrders: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(named: "button_orders_black"), for: .normal)
        return b
    }()
    
    var buttonMap: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(named: "orders_map"), for: .normal)
        return b
    }()
    
    var title: UILabel = {
        var l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 20)
        l.text = "SETTINGS"
        l.textColor = .black
        return l
    }()

    
    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.09)
        
        self.addSubview(buttonOrders)
            
        self.addSubview(buttonMap)
        
        self.addSubview(title)

        buttonOrders.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(self.snp.left).offset(16)
            make.bottom.equalTo(self.snp.bottom).inset(20)
        }
        
        buttonMap.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalTo(self.snp.right).inset(16)
            make.bottom.equalTo(self.snp.bottom).inset(20)
        }

        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(buttonMap)
        }
        
        buttonOrders.addTarget(self, action: #selector(self.buttonOrdersAction(_:)), for: .touchUpInside)
        buttonMap.addTarget(self, action: #selector(self.buttonMapAction(_:)), for: .touchUpInside)
    
    }
    
    @objc func buttonMapAction(_ sender: AnyObject)
    {
        guard let d = self.delegate else {
            return
        }
        
        d.SettingsTopPanelDelegateSwitchToMap()
    }
    
    @objc func buttonOrdersAction(_ sender: AnyObject)
    {
        guard let d = self.delegate else {
            return
        }
        
        d.SettingsTopPanelDelegateSwitchToOrders()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
