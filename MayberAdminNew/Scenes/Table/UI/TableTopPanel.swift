//
//  TableTopPanel.swift
//  MayberAdminNew
//
//  Created by Airtemium on 24.05.2021.
//

import Foundation
import UIKit

protocol TableTopPanelDelegate
{
    func TableTopPanelDelegateBackAction()
    
    func TableTopPanelDelegateMapAction()
}

class TableTopPanel: UIView
{
    var delegate: TableTopPanelDelegate?
    
    var buttonMap: UIButton = {
        var b = UIButton()
        return b
    }()
    
    var buttonBack: UIButton = {
        var b = UIButton()
        return b
    }()
    
    var iconMap: UIImageView = {
        var b = UIImageView()
        b.image = UIImage(named: "button_map_white")
        return b
    }()
    
    var iconBack: UIImageView = {
        var b = UIImageView()
        b.image = UIImage(named: "button_back_white")
        return b
    }()
    
    var tableTitle: UILabel = {
        var l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 18)
        l.textColor = UIColor(red: 255/255, green: 207/255, blue: 0/255, alpha: 1) // 255 207 0
        return l
    }()
    
    var tableSubtitle: UILabel = {
        var l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 18)
        l.textColor = .white
        return l
    }()
    
    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.backgroundColor = .black
        
        self.addSubview(iconMap)
            
        self.addSubview(iconBack)
        
        self.addSubview(buttonBack)
            
        self.addSubview(buttonMap)
        
        self.addSubview(tableSubtitle)
        
        self.addSubview(tableTitle)
        
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
        
        tableSubtitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom).inset(5)
            
        }
        
        tableTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(tableSubtitle.snp.top)            
        }
        
        buttonBack.addTarget(self, action: #selector(self.buttonBackAction(_:)), for: .touchUpInside)
        buttonMap.addTarget(self, action: #selector(self.buttonMapAction(_:)), for: .touchUpInside)
    
    }
    
    @objc func buttonBackAction(_ sender: UIButton)
    {
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.TableTopPanelDelegateBackAction()
    }
    
    @objc func buttonMapAction(_ sender: UIButton)
    {
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.TableTopPanelDelegateMapAction()
    }
    
    func Update(tableName: String, amount: Double, currency: String)
    {
        tableTitle.text = tableName
//        orderCountTitle.text = "\(currency)\(amount)"
        tableSubtitle.text = PriceWithCurrencyFormatter(price: amount, currency: currency)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
