//
//  TableOrderHeader.swift
//  MayberAdminNew
//
//  Created by Airtemium on 25.05.2021.
//

import Foundation
import UIKit

protocol TableOrderHeaderDelegate
{
    func TableOrderHeaderAddAction(checkinUID: String)
    
    func TableOrderHeaderResetAction()
    
    func tableToggleAction(header:TableOrderHeader, indexPath: IndexPath)

}

class TableOrderHeader: UICollectionReusableView
{
    private var didSetupConstraints = false
    
    var delegate: TableOrderHeaderDelegate?
    var indexPath: IndexPath?
    var isVisible: Bool = true 



    private var _checkinUID = ""
    
    var paid: UIImageView = {
        var i = UIImageView()
        i.image = UIImage(named: "table_paid")
        i.isHidden = true
        return i
    }()
    
    var title: UILabel = {
        var l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17)
        l.textColor = .white
        l.numberOfLines = 0
        l.sizeToFit()
        return l
    }()
    
    var amount: UILabel = {
        var l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 17)
        l.textColor = .white
        l.numberOfLines = 0
        l.sizeToFit()
        return l
    }()
    
    var amountLeftToPay: UILabel = {
        var l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17)
        l.textColor = .red
        l.numberOfLines = 0
        l.sizeToFit()
        l.isHidden = true
        return l
    }()
    
    var buttonToggle: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(named: "order_open"), for: .normal)
        b.setImage(UIImage(named: "order_close"), for: .selected)
        return b
    }()
    
    var buttonAdd: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(named: "order_add_dish"), for: .normal)
        return b
    }()
    
    var buttonReset: UIButton = {
        var b = UIButton()
        return b
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1)
        
        self.addSubview(title)
        self.addSubview(amount)
        self.addSubview(amountLeftToPay)
        self.addSubview(buttonToggle)
        self.addSubview(buttonAdd)
        self.addSubview(buttonReset)
        self.addSubview(paid)
        
        title.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview().dividedBy(2)
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
        }
        
        amount.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(self.title.snp.bottom).offset(2)
        }
        
        amountLeftToPay.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(amount.snp.right).offset(16)
            make.top.equalTo(self.title.snp.bottom).offset(2)
        }
        
        
        buttonReset.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview().dividedBy(2)
            make.left.height.equalToSuperview()
        }
        
        buttonToggle.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(34)
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        paid.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(62)
            make.height.equalTo(32)
            make.right.equalToSuperview().inset(55)
            make.centerY.equalToSuperview()
        }
        
        buttonAdd.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(24)
            make.right.equalToSuperview().inset(55)
            make.centerY.equalToSuperview()
        }
        
        buttonToggle.addTarget(self, action: #selector(self.buttonToggleAction(_:)), for: .touchUpInside)
        buttonAdd.addTarget(self, action: #selector(self.buttonAddAction(_:)), for: .touchUpInside)

        buttonReset.addTarget(self, action: "buttonResetAction:", for: .touchUpInside)
    }
    
    @objc func buttonToggleAction(_ sender: AnyObject)
    {
        guard let d = self.delegate else {
            return
        }
        if let existingIndexPath = indexPath {
            d.tableToggleAction(header: self, indexPath: existingIndexPath)
        }
    }
    
    @objc func buttonResetAction(_ sender: AnyObject)
    {
        guard let d = self.delegate else {
            return
        }
        
        d.TableOrderHeaderResetAction()
    }
    
    @objc func buttonAddAction(_ sender: AnyObject)
    {
        guard let d = self.delegate else {
            return
        }
        
        d.TableOrderHeaderAddAction(checkinUID: _checkinUID)
    }
    
    override func updateConstraints()
    {
        if(!didSetupConstraints)
        {

        }
        
        super.updateConstraints()
    }
    
    func Configure(title: String, amount: Double, currency: String, checkinUID: String, leftToPay: Double, status: String)
    {
        _checkinUID = checkinUID
        
        self.title.text = title
        
        self.amount.text = PriceWithCurrencyFormatter(price: amount, currency: currency)
        
        if(leftToPay > 0)
        {
            self.amountLeftToPay.isHidden = false
            self.amountLeftToPay.text = PriceWithCurrencyFormatter(price: leftToPay, currency: currency) + " left"
        }
    }
    
    override func prepareForReuse() {
        self.amountLeftToPay.text = ""
        self.amount.text = ""
        self.title.text = ""
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateArrow()  {
        buttonToggle.isSelected = isVisible == false ? true : false ;
    }
}
