//
//  SeatsMenuItemCell.swift
//  MayberAdminNew
//
//  Created by Airtemium on 30.05.2021.
//

import Foundation
import UIKit
import Kingfisher

protocol SeatsMenuItemCellDelegate
{
    func showCategoryItemsBy(categoryUID: String)
    
    func showDrinksCategory()
    
    func anyActionForMenuItem(uid: String, location: CGPoint, size: CGSize)
    
    func showActionForMenuItem(uid: String)
    
    func getSuperView() -> UIView?
}

class SeatsMenuItemCell: UICollectionViewCell
{
    private var didSetupConstraints = false
    
    private var _item: SeatsMenuItemModel?
    
    var delegate: SeatsMenuItemCellDelegate?
    
    var title: UILabel = {
        var l = UILabel()
        l.numberOfLines = 0
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.textColor = .white
        l.sizeToFit()
        return l
    }()
    
    var cover: UIImageView = {
        var i = UIImageView()
        i.clipsToBounds = true
        i.contentMode = .scaleAspectFill
        return i
    }()
    
    var bg: UIView = {
        var v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        v.isHidden = true
        return v
    }()
    
    var button: UIView = {
        var b = UIView()
        
        return b
    }()

    override init(frame: CGRect)
    {
        super.init(frame: frame)

//        print("*** SeatsMenuItemCell INIT")
        
        self.contentView.backgroundColor = .black
        
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        self.contentView.layer.cornerRadius = 5
        self.contentView.clipsToBounds = true
        
        //cover_debug
//        self.contentView.backgroundColor = UIColor(patternImage: UIImage(named: "cover_debug")!)
        
        self.contentView.addSubview(cover)
        
        self.contentView.addSubview(bg)
        
        self.contentView.addSubview(title)
        
        self.contentView.addSubview(button)
        
        cover.snp.makeConstraints { make in
            make.width.height.top.bottom.left.right.equalToSuperview()
        }
        
        bg.snp.makeConstraints { make in
            make.width.height.top.bottom.left.right.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.width.height.top.bottom.left.right.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.width.height.top.bottom.left.right.equalToSuperview()
        }
        
//        button.addTarget(self, action: #selector(self.itemAction(_:)), for: .touchUpInside)
//        button.addTarget(self, action: #selector(self.itemActionDouble(_:)), for: .touchDownRepeat)
        
        let singleTap =  UITapGestureRecognizer(target: self, action: #selector(self.itemAction(_:)))
        singleTap.numberOfTapsRequired = 1
        button.addGestureRecognizer(singleTap)

            // Double Tap
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.itemActionDouble(_:)))
        doubleTap.numberOfTapsRequired = 2
        button.addGestureRecognizer(doubleTap)

        singleTap.require(toFail: doubleTap)
        singleTap.delaysTouchesBegan = true
        doubleTap.delaysTouchesBegan = true
    }
    
    @objc func itemActionDouble(_ sender: UITapGestureRecognizer)
    {
        print("*** itemActionDouble")
        
        guard let d = self.delegate, let i = self._item else {
            return
        }

        if(_item?.Type == .Item)
        {
            print("*** itemActionDouble SIZE")
            print(self.contentView.getWidth())
            print(self.contentView.getHeight())
            
            let locationOriginal = sender.location(in: self.contentView)
            
            let location = sender.location(in: d.getSuperView())
            
            var size = CGSize(width: self.contentView.getWidth(), height: self.contentView.getHeight())
            
            //
            
            var deltaX = location.x + self.contentView.getWidth() / 2 - locationOriginal.x
            var deltaY = location.y + self.contentView.getHeight() / 2 - locationOriginal.y
                                    
            d.anyActionForMenuItem(uid: i.UID, location: CGPoint(x: deltaX, y: deltaY), size: size)
        }
    }
    
    @objc func itemAction(_ sender: UIButton)
    {
        
        
        guard let d = self.delegate, let i = self._item else {
            return
        }
        
        if(_item?.Type == .DrinkCategory)
        {
            print("** touchUpInside 1")
            d.showDrinksCategory()
        }
        
        if(_item?.Type == .Category)
        {
            print("** touchUpInside 2")
            d.showCategoryItemsBy(categoryUID: i.UID)
        }
        
        if(_item?.Type == .Item)
        {
            print("** touchUpInside 3")
            d.showActionForMenuItem(uid: i.UID)
        }
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
//        self.cover.isHidden = true
        self.bg.isHidden = true
    }
    
//    override func updateConstraints()
//    {
//        print("*** OrderItemCell updateConstraints")
//
//        if (!didSetupConstraints)
//        {
//
//
//            didSetupConstraints = true
//        }
//
//        super.updateConstraints()
//    }
    
    func Configure(item: SeatsMenuItemModel)
    {
        self.layoutIfNeeded()
        
        if(item.Type == .Item)
        {
            self.cover.isHidden = false
            self.bg.isHidden = false
        }
        
        _item = item
        

        
        let url = URL(string: item.PhotoURI)
                
        self.cover.kf.setImage(with: url, placeholder: UIImage(named: "dishThumb"))
        
        self.title.text = item.Title
    }
}

