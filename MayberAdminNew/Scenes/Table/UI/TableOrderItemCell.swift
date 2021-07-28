//
//  TableOrderItemCell.swift
//  MayberAdminNew
//
//  Created by Airtemium on 25.05.2021.
//

import Foundation
import UIKit
import Kingfisher

protocol TableOrderItemCellDelegate
{
    func TableOrderItemActionDouble(orderItemUID: String, checkinUID: String)
    
    func TableOrderItemActionRemove(orderItemUID: String, checkinUID: String)
    
    func TableOrderItemActionRestore(orderItemUID: String, checkinUID: String)
    
    func TableOrderItemActionConfirm(orderItemUID: String, checkinUID: String)
    
    func TableOrderItemActionUnconfirm(orderItemUID: String, checkinUID: String)
    
    func TableOrderItemActionFire(orderItemUID: String, checkinUID: String)
}

class TableOrderItemCell: UICollectionViewCell
{
    var delegate: TableOrderItemCellDelegate?
    
    private var didSetupConstraints = false
    
    private var _item: TableOrderItemModel?
    
    var courseLayout: UIView = {
       var v = UIView()
        v.backgroundColor = .black
        return v
    }()
    
    var courseLabel: UILabel = {
        var l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()
    
    var itemLayout: UIView = {
       var v = UIView()
        v.backgroundColor = .black
        v.clipsToBounds = true
        return v
    }()
    
    var itemLayoutAbove: UIView = {
       var v = UIView()
        v.backgroundColor = .black
        v.alpha = 0.45
        v.clipsToBounds = true
        return v
    }()
    
    var itemImage: UIImageView = {
        var v = UIImageView()
        v.image = UIImage(named: "dishThumb")
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    var itemLabel: UILabel = {
        var l = UILabel()
        l.textAlignment = .center
        l.textColor = .white
        l.font = UIFont.systemFont(ofSize: 18)
        l.numberOfLines = 0
        l.lineBreakMode = .byCharWrapping
        l.sizeToFit()
        return l
    }()
    
    var cover: UIView = {
        var v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        v.isHidden = true
        return v
    }()
    
    // MARK: Buttons
    
    var statusReady: UIImageView = {
        var b = UIImageView()
        b.isHidden = true
        b.image = UIImage(named: "order_item_ready")
        return b
    }()

    
    var buttonRemove: UIButton = {
        var b = UIButton()
        b.isHidden = true
        b.setImage(UIImage(named: "order_remove_dish"), for: .normal)
        return b
    }()


    var buttonDouble: UIButton = {
        var b = UIButton()
        b.isHidden = true
        b.setImage(UIImage(named: "order_double_dish"), for: .normal)
        return b
    }()
    
    var buttonRestore: UIButton = {
        var b = UIButton()
        b.isHidden = true
        b.setImage(UIImage(named: "order_restore_dish"), for: .normal)
        return b
    }()
    
    var buttonUnselected: UIButton = {
        var b = UIButton()
        b.isHidden = true
        b.setImage(UIImage(named: "order_unselect_dish"), for: .normal)
        return b
    }()
    
    var buttonSelected: UIButton = {
        var b = UIButton()
        b.isHidden = true
        b.setImage(UIImage(named: "order_item_selected"), for: .normal)
        return b
    }()
    
    //---
    
    var statusReadyFire1: UIButton = {
        var b = UIButton()
        b.isHidden = true
        b.setImage(UIImage(named: "order_status_fire_1"), for: .normal)
        return b
    }()
    
    var statusReadyFire2: UIButton = {
        var b = UIButton()
        b.isHidden = true
        b.setImage(UIImage(named: "order_status_fire_2"), for: .normal)
        return b
    }()
    
    var statusReadyFire3: UIImageView = {
        var b = UIImageView()
        b.isHidden = true
        b.image = UIImage(named: "order_status_fire_3")
        return b
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
//        self.itemImage.image = nil
        
        self.itemLabel.text = ""
        
        clearAllStatuses()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
//        print("*** OrderItemCell INIT")
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.observerConfimItems(_:)), name: Constants.Notify.OrderConfirmItems, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(self.observerResetConfimItems(_:)), name: Constants.Notify.OrderResetConfirmItems, object: nil)
        
        self.contentView.backgroundColor = .black

        self.contentView.addSubview(courseLayout)
        self.contentView.addSubview(itemLayout)
        
        self.contentView.addSubview(itemLayout)
        //itemLayoutAbove
        
        itemLayout.addSubview(itemImage)
        itemLayout.addSubview(itemLayoutAbove)
        itemLayout.addSubview(itemLabel)
        itemLayout.addSubview(cover)
        itemLayout.addSubview(buttonRemove)
        itemLayout.addSubview(buttonUnselected)
        itemLayout.addSubview(buttonSelected)
        itemLayout.addSubview(buttonDouble)
        itemLayout.addSubview(buttonRestore)
        itemLayout.addSubview(statusReady)
        
        itemLayout.addSubview(statusReadyFire1)
        itemLayout.addSubview(statusReadyFire2)
        itemLayout.addSubview(statusReadyFire3)
        
        courseLayout.addSubview(courseLabel)
        
        courseLayout.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.contentView.snp.left)
            make.right.equalTo(self.contentView.snp.right)
            make.top.equalTo(self.contentView.snp.top)
            make.height.equalTo(35)
        }
        
        courseLabel.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(courseLayout)
            make.left.equalTo(courseLayout.snp.left)
            make.top.equalTo(courseLayout.snp.top)
        }
        
        //---
                                
        itemLayout.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.contentView.snp.left)
            make.right.equalTo(self.contentView.snp.right)
            make.top.equalTo(courseLayout.snp.bottom)
            make.bottom.equalTo(self.contentView.snp.bottom)
        }
        
        itemLayoutAbove.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(itemLayout.snp.left)
            make.top.equalTo(itemLayout.snp.top)
            make.width.height.equalTo(itemLayout)
        }
        
        itemImage.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(itemLayout.snp.left)
            make.top.equalTo(itemLayout.snp.top)
            make.width.height.equalTo(itemLayout)
        }
        
        itemLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(itemLayout.snp.left).offset(5)
            make.right.equalTo(itemLayout.snp.right).inset(5)
            make.bottom.equalTo(itemLayout.snp.bottom).inset(5)
        }
        
        cover.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(itemLayout.snp.left)
            make.top.equalTo(itemLayout.snp.top)
            make.width.height.equalTo(itemLayout)
        }
        
        //
        
        buttonRemove.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(36)
            make.top.equalTo(itemLayout.snp.top).offset(5)
            make.right.equalTo(itemLayout.snp.right).inset(5)
        }
//
        buttonUnselected.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(36)
            make.top.equalTo(itemLayout.snp.top).offset(5)
            make.right.equalTo(itemLayout.snp.right).inset(5)
        }
//
        buttonSelected.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(36)
            make.top.equalTo(itemLayout.snp.top).offset(5)
            make.right.equalTo(itemLayout.snp.right).inset(5)
        }
//
        buttonDouble.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(36)
            make.top.equalTo(itemLayout.snp.top).offset(5)
            make.left.equalTo(itemLayout.snp.left).offset(5)
        }
//
        buttonRestore.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(36)
            make.top.equalTo(itemLayout.snp.top).offset(5)
            make.left.equalTo(itemLayout.snp.left).offset(5)
        }
        
        statusReady.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(64)
            make.center.equalTo(self.itemLayout)
        }
        
        statusReadyFire1.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(52)
            make.top.equalTo(itemLayout.snp.top)
            make.right.equalTo(itemLayout.snp.right)
        }
        
        statusReadyFire2.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(52)
            make.top.equalTo(itemLayout.snp.top)
            make.right.equalTo(itemLayout.snp.right)
        }
        
        statusReadyFire3.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(52)
            make.top.equalTo(itemLayout.snp.top)
            make.right.equalTo(itemLayout.snp.right)
        }
        
        self.buttonDouble.addTarget(self, action: #selector(self.buttonDoubleAction(_:)), for: .touchUpInside)
        self.buttonUnselected.addTarget(self, action: #selector(self.buttonUnselectedAction(_:)), for: .touchUpInside)
        self.buttonSelected.addTarget(self, action: #selector(self.buttonSelectedAction(_:)), for: .touchUpInside)
        self.buttonRemove.addTarget(self, action: #selector(self.buttonRemoveAction(_:)), for: .touchUpInside)
        self.buttonRestore.addTarget(self, action: #selector(self.buttonRestoreAction(_:)), for: .touchUpInside)
        
        statusReadyFire1.addTarget(self, action: #selector(self.orderFire(_:)), for: .touchUpInside)
        statusReadyFire2.addTarget(self, action: #selector(self.orderFire(_:)), for: .touchUpInside)
    }
    
    @objc func orderFire(_ sender: UIButton)
    {
        guard let d = self.delegate, let item = self._item else {
            return
        }
        
        d.TableOrderItemActionFire(orderItemUID: item.OrderItemUID, checkinUID: item.CheckinUID)
    }
    
    @objc func buttonDoubleAction(_ sender: UIButton)
    {
        guard let d = self.delegate, let item = self._item else {
            return
        }
        
        d.TableOrderItemActionDouble(orderItemUID: item.OrderItemUID, checkinUID: item.CheckinUID)
    }
    
    @objc func buttonUnselectedAction(_ sender: UIButton)
    {
        guard let d = self.delegate, let item = self._item else {
            return
        }
        
        self.buttonUnselected.isHidden = true
        self.buttonSelected.isHidden = false
        
        d.TableOrderItemActionConfirm(orderItemUID: item.OrderItemUID, checkinUID: item.CheckinUID)
    }
    
    @objc func buttonSelectedAction(_ sender: UIButton)
    {
        guard let d = self.delegate, let item = self._item else {
            return
        }
        
        self.buttonUnselected.isHidden = false
        self.buttonSelected.isHidden = true
        
        d.TableOrderItemActionUnconfirm(orderItemUID: item.OrderItemUID, checkinUID: item.CheckinUID)
    }
    
    @objc func buttonRemoveAction(_ sender: UIButton)
    {
        guard let d = self.delegate, let item = self._item else {
            return
        }
        
        d.TableOrderItemActionRemove(orderItemUID: item.OrderItemUID, checkinUID: item.CheckinUID)
    }
    
    @objc func buttonRestoreAction(_ sender: UIButton)
    {
        guard let d = self.delegate, let item = self._item else {
            return
        }
        
        d.TableOrderItemActionRestore(orderItemUID: item.OrderItemUID, checkinUID: item.CheckinUID)
    }
    
//    @objc func observerResetConfimItems(_ notification: NSNotification)
//    {
//        DispatchQueue.main.async(execute: {
//            guard let item = self._item else { return }
//
//            if(item.Status == "new")
//            {
//                self.setStatusNew()
//            }
//        })
//    }
    
    @objc func observerConfimItems(_ notification: NSNotification)
    {
        DispatchQueue.main.async(execute: {
            print("*** observerConfimItems")

            guard let item = self._item else { return }
            
            if(item.Status == "new")
            {

                
                self.setStatusReadyToConfirm()
            }
        })
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Configure(item: TableOrderItemModel)
    {
//        print("*** TableOrderItemCell FIRES \(item.Fires)")
        
        self.layoutIfNeeded()
        
        self._item = item
        
//        if(self._item?.Type == .Empty)
//        {
////            self.itemImage.isHidden = true
//            
////            self.contentView.backgroundColor = .red
//            self.itemLabel.text = ""
//            
//            self.itemImage.image = UIImage(named: "dishThumb")
//            
//            return
//        }

                        
        let url = URL(string: item.Image)
        self.itemImage.kf.setImage(with: url, placeholder: UIImage(named: "dishThumb"))
        
        self.itemLabel.text = item.Name
        
//        self._item?.Status = Constants.OrderItemStatus.Closed.rawValue
//        self._item?.Fires = 3
//
//        self._item?.IsDenied = true
        
        processingStatus()
        

    }
    
    func processingStatus()
    {
        if(self._item!.IsDenied)
        {
            self.cover.isHidden = false
            self.buttonRestore.isHidden = false
            
            return
        }
        
        switch(self._item?.Status)
        {
        case Constants.OrderItemStatus.New.rawValue:
            setStatusNew()
            break
        case Constants.OrderItemStatus.Active.rawValue:
            setStatusConfirm()
            break
        case Constants.OrderItemStatus.Canceled.rawValue:
            setStatusDeleted()
            break
        case Constants.OrderItemStatus.Ready.rawValue:
            setStatusReady()
            break;
        case Constants.OrderItemStatus.Closed.rawValue:
            setStatusDone()
            break
        default:
            break
        }
    }

    func clearAllStatuses()
    {
        buttonDouble.isHidden = true

        buttonRemove.isHidden = true
        
        buttonRestore.isHidden = true
        
        buttonSelected.isHidden = true
        
        buttonUnselected.isHidden = true
        
        self.cover.isHidden = true
        
        self.statusReady.isHidden = true
        
        self.statusReadyFire1.isHidden = true
        
        self.statusReadyFire2.isHidden = true
        
        self.statusReadyFire3.isHidden = true
    }
    
    func setStatusDone()
    {
        clearAllStatuses()
        
        self.cover.isHidden = false
        
        self.buttonDouble.isHidden = false
    }
    
    func setStatusNew()
    {
        clearAllStatuses()
        
        buttonDouble.isHidden = false

        buttonRemove.isHidden = false
    }
    
    func setStatusReady()
    {
        clearAllStatuses()
        
        self.cover.isHidden = false
        self.statusReady.isHidden = false
    }
    
    func setStatusReadyToConfirm()
    {
        clearAllStatuses()
        
        self.buttonDouble.isHidden = true

        self.buttonRemove.isHidden = true

        self.buttonUnselected.isHidden = false
    }
    
    func setStatusConfirm()
    {
        clearAllStatuses()
        
//        print("** setStatusReadyToConfirm")
        
        self.setStatusReadyToConfirm()
        
//        self.buttonDouble.isHidden = false
        

        
//        if(_item!.Fires == 1)
//        {
//            self.statusReadyFire2.isHidden = false
//        }
//        else if(_item!.Fires >= 2)
//        {
//            self.statusReadyFire3.isHidden = false
//        }
//        else
//        {
//            self.statusReadyFire1.isHidden = false
//        }
    }
    
    func setStatusDeleted()
    {
        clearAllStatuses()
        
        self.cover.isHidden = false
        
        self.buttonDouble.isHidden = false
    }
    
}
