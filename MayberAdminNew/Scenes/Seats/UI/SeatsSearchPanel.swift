//
//  SeatsSearchPanel.swift
//  MayberAdminNew
//
//  Created by Airtemium on 30.05.2021.
//

import Foundation
import UIKit

protocol SeatsSearchPanelDelegate
{
    func SeatsSearchPanelBackAction(endEditing: Bool)
    
    func SeatsSearchPanelAnyFind(_ text: String)
}

class SeatsSearchPanel: UIView, UITextFieldDelegate
{
    var delegate: SeatsSearchPanelDelegate?
    
    var back: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(named: "menu_back"), for: .normal)
        return b
    }()
    
    var searchLayout: UIView = {
        var v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        v.layer.cornerRadius = 10
        return v
    }()
    
    var searchIcon: UIImageView = {
        var i = UIImageView()
        i.image = UIImage(named: "search_icon")
        return i
    }()
    
    var textField: UITextField = {
        var t = UITextField()
        t.returnKeyType = .done
        t.keyboardAppearance = .dark
        t.text = ""
        t.textColor = UIColor.white
        t.font = UIFont.systemFont(ofSize: 16)
        t.backgroundColor = .clear
        t.attributedPlaceholder = NSAttributedString(string: "Search menu item", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.65)
        ])
        return t
    }()
    
    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.backgroundColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1)
        
        self.addSubview(back)
        
        self.addSubview(searchLayout)
        
        searchLayout.addSubview(textField)
        
        searchLayout.addSubview(searchIcon)
        
        back.snp.makeConstraints { make in
            make.width.height.equalTo(42)
            make.left.equalTo(self.snp.left).offset(9)
            make.top.equalTo(self.snp.top).offset(3.5)
        }
        
        searchLayout.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.left.equalTo(back.snp.right).offset(4)
            make.top.equalTo(self.snp.top).offset(6)
            make.right.equalTo(self.snp.right).inset(15)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.left.equalTo(searchLayout.snp.left).offset(10)
            make.width.height.equalTo(14)
            make.centerY.equalTo(searchLayout)
        }
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(searchIcon.snp.right).offset(10)
            make.top.equalTo(searchLayout.snp.top)
            make.bottom.equalTo(searchLayout.snp.bottom)
            make.right.equalTo(searchLayout.snp.right).offset(-10)
        }
        
        back.addTarget(self, action: #selector(self.actionBack(_:)), for: .touchUpInside)
        
        textField.delegate = self
        
        textField.addTarget(self, action: #selector(self.searchChanged(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func actionBack(_ sender: AnyObject)
    {
        guard let d = self.delegate else { return }
        
        d.SeatsSearchPanelBackAction(endEditing: true)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func searchChanged(_ sender: UITextField)
    {
        guard let d = self.delegate else { return }
        
        if(sender.text!.count > 0)
        {
            d.SeatsSearchPanelAnyFind(sender.text!)
        }
        else
        {
            d.SeatsSearchPanelBackAction(endEditing: false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print("*** textFieldShouldReturn")
        
        self.endEditing(true)
                        
        return false
    }
}
