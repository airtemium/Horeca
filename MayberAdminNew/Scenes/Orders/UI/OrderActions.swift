//
//  OrderActions.swift
//  MayberAdminNew
//
//  Created by Airtemium on 21.05.2021.
//

import Foundation
import UIKit

protocol OrderActionsDelegate
{
    func OrderActionsDelegateCancel()
    
    func OrderActionsDelegateProblems(tableUID: String)
    
    func OrderActionsDelegateOrderPaid(tableUID: String)
    
    func OrderActionsDelegateCloseCheckIn(tableUID: String)
}

class OrderActions: UIView
{
    var delegate: OrderActionsDelegate?
    
    private var _tableUID: String = ""
    
    var close: UIImageView = {
        var i = UIImageView()
        i.image = UIImage(named: "orders_close")
        return i
    }()
    
    var bg: UIView = {
        var b = UIView()
        b.alpha = 0
        b.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return b
    }()
    
    var layout: UIView = {
        var l = UIView()
        l.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        l.layer.cornerRadius = 10
        return l
    }()
    
    var tableTitleLabel: UILabel = {
        var l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 12)
        l.sizeToFit()
        l.textColor = UIColor(red: 142/255, green: 142/255, blue: 142/255, alpha: 1)
        return l
    }()
    
    var tableNumberLabel: UILabel = {
        var l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 24)
        l.sizeToFit()
        l.textColor = .black
        return l
    }()
    
    var separator: UIView = {
        var r = UIView()
        r.backgroundColor = UIColor(red: 229/255, green: 230/255, blue: 234/255, alpha: 1)//229 230 234
        return r
    }()
    
    var guestsLabel: UILabel = {
        var l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 24)
        l.sizeToFit()
        l.textColor = .black
        return l
    }()
    
    var amountLabel: UILabel = {
        var l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 24)
        l.numberOfLines = 0
        l.sizeToFit()
        l.textColor = .black
        l.textAlignment = .right
        return l
    }()
    
    var buttonCancel: UIButton = {
        var b = UIButton()
        b.backgroundColor = UIColor.white
        b.layer.cornerRadius = 14
        b.setTitle("Cancel", for: .normal)
        b.setTitleColor(.black, for: .normal)
        return b
    }()
    
    var actionsLayout: UIView = {
        var b = UIView()
        b.backgroundColor = UIColor.white
        b.layer.cornerRadius = 14
        b.layer.masksToBounds = true
        return b
    }()
    
    var buttonClose: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(named: "orders_close"), for: .normal)
        return b
    }()
    
    //---
    
    var partyName: UILabel = {
        var l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20)
        l.textColor = .black
        l.textAlignment = .left
        return l
    }()
//
    var partyNameLabel: UILabel = {
        var l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 12)
        l.sizeToFit()
        l.textColor = UIColor(red: 142/255, green: 142/255, blue: 142/255, alpha: 1)
        return l
    }()
    
    //---
    
    var buttonProblems: UIButton = {
        var b = UIButton()
//        b.isEnabled = false
        b.backgroundColor = UIColor.clear
        b.layer.cornerRadius = 14
        b.setTitle("Problems", for: .normal)
        b.setTitleColor(.black, for: .normal)
        return b
    }()
    
    var buttonOrderPaid: UIButton = {
        var b = UIButton()
        b.backgroundColor = UIColor.clear
        b.layer.cornerRadius = 14
        b.setTitle("Paid in cash", for: .normal)
        b.setTitleColor(.black, for: .normal)
        return b
    }()
    
    var buttonCloseCheckin: UIButton = {
        var b = UIButton()
//        b.isEnabled = false
        
        b.backgroundColor = UIColor.clear
        b.layer.cornerRadius = 14
        b.setTitle("Paid by the client", for: .normal)
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
    
    //---
    
    init(table: Int, guests: Int, amount: Double, currency: String, partyName: String, tableUID: String)
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        print("*** OrderActions INIT")
        
        _tableUID = tableUID
        
        self.addSubview(bg)
        self.addSubview(layout)
        
        layout.addSubview(tableNumberLabel)
        layout.addSubview(tableTitleLabel)
        layout.addSubview(separator)
        layout.addSubview(guestsLabel)
        layout.addSubview(amountLabel)
        layout.addSubview(buttonClose)
        
        layout.addSubview(self.partyName)
        layout.addSubview(partyNameLabel)
        layout.addSubview(buttonCancel)
        layout.addSubview(actionsLayout)
        
        actionsLayout.addSubview(buttonProblems)
        actionsLayout.addSubview(buttonOrderPaid)
        actionsLayout.addSubview(buttonCloseCheckin)
        actionsLayout.addSubview(separatorActions1)
        actionsLayout.addSubview(separatorActions2)
        
        bg.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.top.left.right.bottom.equalToSuperview()
        }
        
        
        layout.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.snp.bottom)
            make.height.equalToSuperview().dividedBy(2)
        }
        
//        layout.backgroundColor = .red

        buttonClose.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.right.equalTo(self.layout.snp.right).inset(16)
            make.top.equalTo(self.layout.snp.top).offset(16)
        }

        tableNumberLabel.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(26)
            make.left.equalTo(self.layout.snp.left).offset(16)
            make.top.equalTo(self.layout.snp.top).offset(18)
        }

        tableTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(10)
            make.left.equalTo(self.layout.snp.left).offset(16)
            make.top.equalTo(self.tableNumberLabel.snp.bottom)
        }



        guestsLabel.snp.makeConstraints { make in
            make.width.equalTo(135)
            make.height.equalTo(26)
            make.left.equalTo(self.layout.snp.left).offset(16)
            make.top.equalTo(self.tableTitleLabel.snp.bottom).offset(24)
        }

        amountLabel.snp.makeConstraints { make in
//            make.width.equalTo(135)
            make.height.equalTo(26)
            make.right.equalTo(self.layout.snp.right).inset(16)
            make.top.equalTo(self.tableTitleLabel.snp.bottom).offset(24)
        }

        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalTo(self.layout.snp.left).offset(16)
            make.right.equalTo(self.layout.snp.right).inset(16)
            make.top.equalTo(self.guestsLabel.snp.bottom).offset(5)
        }

        //--

        self.partyName.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.left.equalTo(self.layout.snp.left).offset(16)
            make.right.equalTo(self.layout.snp.right).inset(16)
            make.top.equalTo(self.separator.snp.bottom).offset(9)
        }

        partyNameLabel.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(15)
            make.left.equalTo(self.layout.snp.left).offset(16)
            make.top.equalTo(self.partyName.snp.bottom)
        }

        actionsLayout.snp.makeConstraints { make in
            make.left.equalTo(layout.snp.left).offset(12)
            make.right.equalTo(layout.snp.right).inset(12)
            make.height.equalTo(168)
            make.top.equalTo(partyNameLabel.snp.bottom).offset(40)
        }

        buttonCancel.snp.makeConstraints { make in
            make.left.equalTo(layout.snp.left).offset(12)
            make.right.equalTo(layout.snp.right).inset(12)
            make.height.equalTo(56)
            make.top.equalTo(actionsLayout.snp.bottom).offset(8)
        }

        //---

        buttonProblems.snp.makeConstraints { make in
            make.left.equalTo(actionsLayout.snp.left)
            make.right.equalTo(actionsLayout.snp.right)
            make.height.equalTo(56)
            make.top.equalTo(actionsLayout.snp.top)
        }

        buttonOrderPaid.snp.makeConstraints { make in
            make.left.equalTo(actionsLayout.snp.left)
            make.right.equalTo(actionsLayout.snp.right)
            make.height.equalTo(56)
            make.top.equalTo(buttonProblems.snp.bottom)
        }

        buttonCloseCheckin.snp.makeConstraints { make in
            make.left.equalTo(actionsLayout.snp.left)
            make.right.equalTo(actionsLayout.snp.right)
            make.height.equalTo(56)
            make.top.equalTo(buttonOrderPaid.snp.bottom)
        }

        separatorActions1.snp.makeConstraints { make in
            make.left.equalTo(actionsLayout.snp.left)
            make.right.equalTo(actionsLayout.snp.right)
            make.height.equalTo(1)
            make.bottom.equalTo(buttonProblems.snp.bottom)
        }

        separatorActions2.snp.makeConstraints { make in
            make.left.equalTo(actionsLayout.snp.left)
            make.right.equalTo(actionsLayout.snp.right)
            make.height.equalTo(1)
            make.bottom.equalTo(buttonOrderPaid.snp.bottom)
        }

        //---

        buttonClose.addTarget(self, action: #selector(self.actionClose(_:)), for: .touchUpInside)
        buttonProblems.addTarget(self, action: #selector(self.actionProblems(_:)), for: .touchUpInside)
        buttonOrderPaid.addTarget(self, action: #selector(self.actionOrderPaid(_:)), for: .touchUpInside)
        buttonCloseCheckin.addTarget(self, action: #selector(self.actionCloseCheckin(_:)), for: .touchUpInside)
        buttonCancel.addTarget(self, action: #selector(self.actionClose(_:)), for: .touchUpInside)


        //---

        self.tableNumberLabel.text = String(table)
        self.tableTitleLabel.text = "table"
        self.guestsLabel.text = "Guests: \(guests)"
        self.amountLabel.text = PriceWithCurrencyFormatter(price: amount, currency: currency)
        
        

        if(!partyName.isEmpty)
        {
            self.partyName.text = partyName
            self.partyNameLabel.text = "Party name"
        }


        
        self.layoutIfNeeded()
    }
    
    @objc func actionClose(_ sender: UIButton)
    {
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.OrderActionsDelegateCancel()
        
        self.Hide()
    }
    
    @objc func actionProblems(_ sender: UIButton)
    {
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.OrderActionsDelegateProblems(tableUID: _tableUID)
        
        self.Hide()
    }
    
    @objc func actionOrderPaid(_ sender: UIButton)
    {
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.OrderActionsDelegateOrderPaid(tableUID: _tableUID)
        
        self.Hide()
    }
    
    @objc func actionCloseCheckin(_ sender: UIButton)
    {
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.OrderActionsDelegateCloseCheckIn(tableUID: _tableUID)
        
        self.Hide()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Show()
    {
        self.layoutIfNeeded()

        UIView.animate(withDuration: 0.5, animations: {
            self.bg.alpha = 1
            
            self.layout.snp.remakeConstraints { make in
                make.bottom.equalToSuperview()
                make.width.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo((DeviceType.IS_IPHONE_8 || DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_8P) ? ScreenSize.SCREEN_HEIGHT * 0.7 : ScreenSize.SCREEN_HEIGHT / 2)
            }

            self.layoutIfNeeded()
            
        }) { (success) in

        }
    }
    
    func Hide()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.bg.alpha = 0
            
            self.layout.snp.remakeConstraints { make in
                make.top.equalTo(self.snp.bottom)
                make.width.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalToSuperview().dividedBy(1.8)
            }
            
            self.layoutIfNeeded()
            
        }) { (success) in
            self.snp.removeConstraints()
            
            self.removeFromSuperview()
        }
    }
}
