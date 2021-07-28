//
//  TableMenuCollection.swift
//  MayberAdminNew
//
//  Created by Airtemium on 01.06.2021.
//

import Foundation
import UIKit

protocol TableMenuCollectionManupulationDelegate
{
    func TableMenuCollectionManupulationDelegateOffsetUp()
    
    func TableMenuCollectionManupulationDelegateOffsetDown()
}

protocol TableMenuCollectionDelegate
{
    func getMenuItemsCount() -> Int
    
    func getMenuItemByIdx(idx: Int) -> SeatsMenuItemModel
    
    func showMenuCategoryItemsBy(categoryUID: String, menu: SeatsMenuCollection)
    
    func anyMenuActionForMenuItem(uid: String, checkinUID: String, location: CGPoint, size: CGSize)
    
    func MenuReloadCategories(menu: SeatsMenuCollection)
    
    func TableMenuCollectionHide()
    
    func searchPanelAnyFind(_ text: String, menu: SeatsMenuCollection)
    
    func showActionForMenuItem(uid: String)
}

class TableMenuCollection: UIView
{
    private var _checkinUID = ""
    
    var delegate: TableMenuCollectionDelegate?
    
    var manipulationDelegate: TableMenuCollectionManupulationDelegate?
    
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
        l.backgroundColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1)
        l.layer.cornerRadius = 14
        l.layer.masksToBounds = true
        return l
    }()
    
    var tableTitleLabel: UILabel = {
        var l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 12)
        l.sizeToFit()
        l.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        return l
    }()
    
    var tableNumberLabel: UILabel = {
        var l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 24)
        l.sizeToFit()
        l.textColor = .white
        return l
    }()
    
    //120 120 128, 0.36
    

    var separator: UIView = {
        var r = UIView()
        r.backgroundColor = UIColor(red: 120/255, green: 120/255, blue: 128/255, alpha: 0.36)//229 230 234
        return r
    }()
    
    var guestsLabel: UILabel = {
        var l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 24)
        l.sizeToFit()
        l.textColor = .white
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

    
    var actionsLayout: UIView = {
        var b = UIView()
        b.backgroundColor = UIColor.white

        return b
    }()
    
    var partyName: UILabel = {
        var l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20)
        l.textColor = .white
        l.textAlignment = .left
        return l
    }()
    
    var buttonClose: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(named: "button_close"), for: .normal)
        return b
    }()
//
    var partyNameLabel: UILabel = {
        var l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 12)
        l.sizeToFit()
        l.textColor = UIColor(red: 142/255, green: 142/255, blue: 142/255, alpha: 1)
        return l
    }()
    
    var layoutMenu: SeatsMenuCollection = {
        var v = SeatsMenuCollection()
        return v
    }()
    
    var search: SeatsSearchPanel = {
        var v = SeatsSearchPanel()
        return v
    }()
    
    func getCurrentCheckin() -> String
    {
        return _checkinUID
    }
    
    func reloadAmount(amount: Double, currency: String)
    {
        self.amountLabel.text = "\(currency)\(amount)"
    }
    

    init(table: Int, guest: Int, amount: Double, currency: String, numberOfDishes: Int, tableUID: String, checkinUID: String, delegate: TableMenuCollectionDelegate)
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.delegate = delegate

        _checkinUID = checkinUID
        
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
        layout.addSubview(actionsLayout)
        

        actionsLayout.addSubview(search)
        actionsLayout.addSubview(layoutMenu)
        
        bg.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.top.left.right.bottom.equalToSuperview()
        }
        
        
        layout.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
//            make.bottom.equalTo(self.snp.bottom).offset(40)
//            make.top.equalTo(ScreenSize.SCREEN_WIDTH / 2)
            make.top.equalTo(self.snp.bottom)
            make.height.equalToSuperview().dividedBy(1.2)
        }
        
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
            make.width.equalTo(135)
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
            make.left.equalTo(layout.snp.left)
            make.right.equalTo(layout.snp.right)
            make.bottom.equalTo(self.layout.snp.bottom).offset(-40)
            make.top.equalTo(partyNameLabel.snp.bottom).offset(40)
        }
        
        //---
        
        search.snp.makeConstraints { make in
            make.top.equalTo(actionsLayout.snp.top)
            make.left.equalTo(actionsLayout.snp.left)
            make.right.equalTo(actionsLayout.snp.right)
            make.height.equalTo(49)
        }
        
        layoutMenu.snp.makeConstraints { make in
            make.width.equalTo(actionsLayout.snp.width)
            make.left.equalTo(actionsLayout.snp.left)
            make.right.equalTo(actionsLayout.snp.right)
            make.top.equalTo(search.snp.bottom)
            make.bottom.equalTo(actionsLayout.snp.bottom)
        }

        //---
        

        
        //---
        
        self.tableNumberLabel.text = String(table)
        self.tableTitleLabel.text = "Table"
        self.guestsLabel.text = "Guest name"
        self.amountLabel.text = "\(currency)\(amount)"
        

        self.partyName.text = "\(numberOfDishes)"
        self.partyNameLabel.text = "Number of dishes"
        
        
        buttonClose.addTarget(self, action: #selector(self.actionClose(_:)), for: .touchUpInside)
        
        layoutMenu.delegate = self
        layoutMenu.manipulationDelegate = self
        search.delegate = self
        
        self.layoutIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerExternalAddMenuItem(_:)), name: Constants.Notify.DetailsAddMenuItem, object: nil)
    }
    
    @objc func observerExternalAddMenuItem(_ notification: NSNotification)
    {
        print("*** observerExternalAddMenuItem")
        
        DispatchQueue.main.async { [weak self] in
            guard
                let userInfo = notification.userInfo
            else {
                return
            }
            
            let menuItemUID = userInfo["menu_item_uid"] as? String
            
            guard let d = self?.delegate else {
                return
            }
            
            print("*** anyActionForMenuItem 2")
                            
            d.anyMenuActionForMenuItem(uid: menuItemUID!, checkinUID: self!._checkinUID, location: CGPoint(x: 0, y: 0), size: .zero)
        }
    }
    
    deinit {
        print("*** TableMenuCollection")
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func actionClose(_ sender: UIButton)
    {
//        guard let delegate = self.delegate else {
//            return
//        }
//
//        delegate.OrderActionsDelegateCancel()
        
        
        
        self.Hide()
    }
    
    func Show()
    {
        self.layoutIfNeeded()

        UIView.animate(withDuration: 0.5, animations: {
            self.bg.alpha = 1
            
            self.layout.snp.remakeConstraints { make in
                make.top.equalTo(ScreenSize.SCREEN_HEIGHT * 0.2)
                make.width.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(ScreenSize.SCREEN_HEIGHT * 0.85)
            }

            self.layoutIfNeeded()
            
        }) { (success) in

        }
    }
    
    func Hide()
    {
        print("*** TableMenuCollection HIDE 1")
        
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
            print("*** TableMenuCollection HIDE 2")
                        
            guard let d = self.delegate else { return }
            
            d.TableMenuCollectionHide()
            
            self.snp.removeConstraints()
            
            self.removeFromSuperview()
        }
    }
}

extension TableMenuCollection: SeatsMenuCollectionDelegate, SeatsSearchPanelDelegate, SeatsMenuCollectionManipulationDelegate
{
    func showDrinksCategory() {
        
    }
    
    func SeatsMenuCollectionDelegateOffsetUp()
    {
        guard let d = manipulationDelegate else {
            return
        }
        
        d.TableMenuCollectionManupulationDelegateOffsetUp()
    }
    
    func SeatsMenuCollectionDelegateOffsetDown()
    {
        guard let d = manipulationDelegate else {
            return
        }
        
        d.TableMenuCollectionManupulationDelegateOffsetDown()
    }
    
    func showActionForMenuItem(uid: String)
    {
        guard let d = self.delegate else {
            return
        }
        
        d.showActionForMenuItem(uid: uid)
    }
    
    func SeatsSearchPanelAnyFind(_ text: String)
    {
        guard let d = self.delegate else {
            return
        }
        
        d.searchPanelAnyFind(text, menu: self.layoutMenu)
    }
    
    func SeatsSearchPanelBackAction(endEditing: Bool)
    {
        guard let d = self.delegate else {
            return
        }
        
        d.MenuReloadCategories(menu: self.layoutMenu)
    }
    
    func getItemsCount() -> Int
    {
        guard let d = self.delegate else {
            return 0
        }
                        
        return d.getMenuItemsCount()
    }
    
    func getItemByIdx(idx: Int) -> SeatsMenuItemModel
    {
        guard let d = self.delegate else {
            return SeatsMenuItemModel()
        }
                        
        return d.getMenuItemByIdx(idx: idx)
    }
    
    func showCategoryItemsBy(categoryUID: String)
    {
        guard let d = self.delegate else {
            return
        }
                        
        d.showMenuCategoryItemsBy(categoryUID: categoryUID, menu: self.layoutMenu)
    }
    
    func anyActionForMenuItem(uid: String, location: CGPoint, size: CGSize)
    {
        print("*** anyActionForMenuItem 1")
        
        guard let d = self.delegate else {
            return
        }
        
        print("*** anyActionForMenuItem 2")
                        
        d.anyMenuActionForMenuItem(uid: uid, checkinUID: _checkinUID, location: location, size: size)
    }
}
