//
//  OrdersCell.swift
//  MayberAdminNew
//
//  Created by Artem on 19.05.2021.
//

import Foundation
import UIKit

protocol OrdersCellDelegate
{
    func OrdersCellDelegateAction(item: TableOrders)
}

class OrdersCell: UITableViewCell
{
    var didSetupConstraints = false
    
    var delegate: OrdersCellDelegate?
    
    private var item: TableOrders?
    
    var layout: UIView = {
        var l = UIView()
        l.backgroundColor = .white
        return l
    }()
    
    var colorSelection: UIView = {
        var r = UIView()
        r.backgroundColor = .randomColor()
        return r
    }()
    
    var actionButton: UIButton = {
        var b = UIButton()
//        b.backgroundColor = .red
        b.setImage(UIImage(named: "orders_actions"), for: .normal)
        return b
    }()
    
    var iconDone: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(named: "orders_done"), for: .normal)
        return b
    }()
    
    var separator: UIView = {
        var r = UIView()
        r.backgroundColor = UIColor(red: 229/255, green: 230/255, blue: 234/255, alpha: 1)//229 230 234
        return r
    }()
    
    var tableNumberLabel: UILabel = {
        var l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 24)
        l.sizeToFit()
        l.textColor = .black
        return l
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
        l.sizeToFit()
        l.textColor = .black
        l.textAlignment = .right
        return l
    }()
    
    var tableTitleLabel: UILabel = {
        var l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 12)
        l.sizeToFit()
        l.textColor = UIColor(red: 142/255, green: 142/255, blue: 142/255, alpha: 1)
        return l
    }()
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = UIColor.clear

        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        self.contentView.addSubview(layout)
        
        self.layout.addSubview(colorSelection)
        
        self.layout.addSubview(tableNumberLabel)
        
        self.layout.addSubview(tableTitleLabel)
        
        self.layout.addSubview(separator)
        
        self.layout.addSubview(guestsLabel)
        
        self.layout.addSubview(amountLabel)
        
        self.layout.addSubview(actionButton)
        
        self.layout.addSubview(partyName)
        
        self.layout.addSubview(partyNameLabel)
        
        actionButton.addTarget(self, action: #selector(self.actionButtonTarget(_:)), for: .touchUpInside)
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints()
    {
//        print("** OrdersCell updateConstraints")
        
        if (!didSetupConstraints)
        {
            layout.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.top.equalToSuperview()
                make.height.equalToSuperview().inset(5)
            }
            
            colorSelection.snp.makeConstraints { make in
                make.width.equalTo(10)
                make.left.equalTo(self.layout.snp.left)
                make.top.equalTo(self.layout.snp.top)
                make.bottom.equalTo(self.layout.snp.bottom)
            }

            tableNumberLabel.snp.makeConstraints { make in
                make.width.equalTo(48)
                make.height.equalTo(26)
                make.left.equalTo(self.layout.snp.left).offset(26)
                make.top.equalTo(self.layout.snp.top).offset(11)
            }
//
            tableTitleLabel.snp.makeConstraints { make in
                make.width.equalTo(48)
                make.height.equalTo(10)
                make.left.equalTo(self.layout.snp.left).offset(26)
                make.top.equalTo(self.tableNumberLabel.snp.bottom)
            }


//
            guestsLabel.snp.makeConstraints { make in
                make.width.equalTo(135)
                make.height.equalTo(26)
                make.left.equalTo(self.layout.snp.left).offset(26)
                make.top.equalTo(self.tableTitleLabel.snp.bottom).offset(20)
            }

            amountLabel.snp.makeConstraints { make in
//                make.width.equalTo(135)
                make.height.equalTo(26)
                make.right.equalTo(self.layout.snp.right).inset(16)
                make.top.equalTo(self.tableTitleLabel.snp.bottom).offset(20)
            }
            
            separator.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.left.equalTo(self.layout.snp.left).offset(26)
                make.right.equalTo(self.layout.snp.right).inset(16)
                make.top.equalTo(self.guestsLabel.snp.bottom).offset(5)
            }
//
            actionButton.snp.makeConstraints { make in
                make.width.height.equalTo(40)
                make.right.equalTo(self.layout.snp.right).inset(8)
                make.top.equalTo(self.layout.snp.top).inset(8)
            }
            
            //---
            
            partyName.snp.makeConstraints { make in
                make.height.equalTo(26)
                make.left.equalTo(self.layout.snp.left).offset(26)
                make.right.equalTo(self.layout.snp.right).inset(26)
                make.top.equalTo(self.separator.snp.bottom).offset(4)
            }
            
            partyNameLabel.snp.makeConstraints { make in
                make.width.equalTo(150)
                make.height.equalTo(15)
                make.left.equalTo(self.layout.snp.left).offset(26)
                make.top.equalTo(self.partyName.snp.bottom)
            }
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    func initShadow()
    {
        layout.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        layout.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layout.layer.masksToBounds = false
        layout.layer.shadowRadius = 2
        layout.layer.shadowOpacity = 0.5
        layout.layer.shouldRasterize = true
        layout.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        tableTitleLabel.text = ""
        guestsLabel.text = ""
        tableNumberLabel.text = ""
        amountLabel.text = ""
        partyName.text = ""
        partyNameLabel.text = ""
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
    }
    
    func Configure(item: TableOrders)
    {
//        print("*** OrdersCell Configure")
        
        self.item = item
        
        initShadow()
        
        tableTitleLabel.text = "Table"
        
        tableNumberLabel.text = "\(item.TableNumber)"
        
        guestsLabel.text = "Guests: \(item.GuestCount)"
                
        amountLabel.text = PriceWithCurrencyFormatter(price: item.AmountTotal, currency: item.AmountTotalCurrency)
                
        if(!item.PartyName.isEmpty)
        {
            partyName.text = item.PartyName
            partyNameLabel.text = "Party name"
        }
    }
    
    @objc func actionButtonTarget(_ sender: UIButton)
    {
        guard let delegate = self.delegate else {
            return
        }
        
        guard let item = self.item else {
            return
        }
        
        delegate.OrdersCellDelegateAction(item: item)
    }
}
