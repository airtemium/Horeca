//
//  OrderstopPanel.swift
//  MayberAdminNew
//
//  Created by Artem on 19.05.2021.
//

import Foundation
import UIKit

protocol MapTopPanelDelegate
{
    func MapTopPanelDelegateGoToOrdersAction()
    
    func MapTopPanelDelegateGoToProfile()
}

class MapTopPanel: UIView
{
    var delegate: MapTopPanelDelegate?
    
    var buttonGoToProfile: UIButton = {
        var b = UIButton()
        return b
    }()
    
    var buttonGoToOrders: UIButton = {
        var b = UIButton()
        return b
    }()
    
    var iconGoToProfile: UIImageView = {
        var b = UIImageView()
        b.image = UIImage(named: "orders_profile")
        return b
    }()
    
    var iconGoToOrders: UIImageView = {
        var b = UIImageView()
        b.image = UIImage(named: "button_orders_black")
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
        
        self.addSubview(iconGoToProfile)
            
        self.addSubview(iconGoToOrders)
        
        self.addSubview(buttonGoToOrders)
            
        self.addSubview(buttonGoToProfile)
        
        self.addSubview(orderTitle)
        
        self.addSubview(orderCountTitle)
        
        iconGoToProfile.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(self.snp.left).offset(16)
            make.bottom.equalTo(self.snp.bottom).inset(20)
        }
        
        iconGoToOrders.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalTo(self.snp.right).inset(16)
            make.bottom.equalTo(self.snp.bottom).inset(20)
        }
        
        //---
        
        buttonGoToProfile.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(24 + 16 + 15)
        }
        
        buttonGoToOrders.snp.makeConstraints { make in
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
    
        buttonGoToOrders.addTarget(self, action: #selector(self.buttonGoToOrdersAction(_:)), for: .touchUpInside)
        
        buttonGoToProfile.addTarget(self, action: #selector(self.buttonGoToProfileAction(_:)), for: .touchUpInside)
    }
    
    @objc func buttonGoToProfileAction(_ sender: AnyObject)
    {
        guard let d = self.delegate else {
            return
        }
        
        d.MapTopPanelDelegateGoToProfile()
    }
    
    @objc func buttonGoToOrdersAction(_ sender: AnyObject)
    {
        guard let d = self.delegate else {
            return
        }
        
        d.MapTopPanelDelegateGoToOrdersAction()
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
