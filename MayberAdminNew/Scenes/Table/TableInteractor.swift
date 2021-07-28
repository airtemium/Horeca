//
//  MainInteractor.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation

final class TableInteractor
{
    private var _tableUID: String = ""
    
    private var _data = [TableOrderModel]()
    
    private var _currency = ""
    
    init(tableUID: String)
    {
        self._tableUID = tableUID
        
        _initData()
    }
    
    func getPlaceCurrency() -> String
    {
        if(!_currency.isEmpty)
        {
            return _currency
        }
        
        guard let r = DB.shared.getRealm, let place = r.objects(UsersPlaceModel.self).first else {
            return "$"
        }
        
        _currency = place.Currency
        
        return _currency
    }
    
    func _initData()
    {
        _data = [TableOrderModel]()
        
        guard let r = DB.shared.getRealm else {
            return
        }
        
        let checkins = r.objects(CheckinModel.self).filter("status = 'approved' AND isRemoved = false AND tableUid = '\(self._tableUID)'  AND status IN %@", ["new", "approved"]).sorted(byKeyPath: "guestNumber", ascending: true)
        
        for checkin in checkins
        {                        
            let o1 = TableOrderModel()
            o1.CheckinUID = checkin.checkinUid
            o1.Name = "Guest \(checkin.guestNumber)"
            o1.TableUID = checkin.tableUid
            
            o1.GuestNumber = checkin.guestNumber
            o1.TableNumber = checkin.number
            o1.LeftToPay = checkin.leftToPay
            o1.Payed = checkin.payed
            o1.Status = checkin.status
            
            let orderItems = r.objects(OrderItemModel.self).filter("IsRemoved = false AND CheckinUID = '\(checkin.checkinUid)'")
            
            for item in orderItems
            {
                let oi1 = TableOrderItemModel()
                oi1.Type = .Base
                oi1.OrderItemUID = item.UID
                oi1.MenuItemUID = item.MenuItemUID                
                oi1.CheckinUID = checkin.checkinUid
                oi1.Cost = item.Price
                oi1.Currency = self.getPlaceCurrency()
                oi1.Image = item.PhotoURI
                oi1.Name = item.Title
                oi1.Status = item.Status
                oi1.IsDenied = item.Denied
                oi1.Fires = item.FiresNumber
                
                o1.Items.append(oi1)
            }
            
            if(o1.Items.count % 2 == 1)
            {
                let oi2 = TableOrderItemModel()
                oi2.Type = .Empty
                o1.Items.append(oi2)
            }
            
            _data.append(o1)
        }
    }
}

// MARK: - Extensions -

extension TableInteractor: TableInteractorProtocol
{
    func RestoreOrderItem(orderItemUID: String, checkinUID: String, beforeExternelRemove: @escaping () -> ())
    {
        guard let r = DB.shared.getRealm else { return }
        
        if let order = r.objects(OrderItemModel.self).filter("UID = '\(orderItemUID)'").first
        {
            try! r.write {
                order.Denied = false
            }
            
            beforeExternelRemove()
        }
    }
    
    func RemoveOrderItem(orderItemUID: String, checkinUID: String, beforeExternelRemove: @escaping () -> (), success: @escaping () -> (), failure: @escaping (_ error: String) -> ())
    {
        
        print("*** INTERACTOR ** RemoveOrderItem \(orderItemUID)")
        
        guard let r = DB.shared.getRealm, let tableUID = _data.first?.TableUID else { return }
        
        if let order = r.objects(OrderItemModel.self).filter("UID = '\(orderItemUID)'").first
        {
            try! r.write {
                order.Denied = true
                order.Status = "canceled"
            }
            
            beforeExternelRemove()
        }

        let place = r.objects(UsersPlaceModel.self).first
        
        print("*** TableInteractor RemoveOrderItem 3")
        
        let user = r.objects(UserModel.self).first
        
        let orderManager = OrderManager(checkinUID: checkinUID, tableUID: tableUID, placeUID: place!.placeUid, userUID: user!.userUid)

        orderManager.Deny(data: [orderItemUID]) { error in
            failure(error)
        } completitionSuccess: {
            success()
        }
    }
    
    func getTableUID() -> String
    {
        return _tableUID
    }
    
    func removeTableOrderItem(order: Int, item: Int)
    {
        //return self.interactor.getData()[order].Items[item]
        //data[sourceIndexPath.section].remove(at: sourceIndexPath.item)
        
        _data[order].Items.remove(at: item)
    }
    
    func addTableOrderItem(object: TableOrderItemModel, order: Int, item: Int, finish: @escaping () -> (), failure: @escaping () -> ())
    {
        let newCheckin = _data[order].CheckinUID
        
        let oldCheckin = object.CheckinUID
        
        if(newCheckin == oldCheckin)
        {
            failure()
            
            return
        }
        
        _data[order].Items.insert(object, at: item)
        
        //--
        
        guard let r = DB.shared.getRealm, let tableUID = _data.first?.TableUID else {
            print("*** addTableOrderItem 2")
            failure()
            return
        }
        
        let place = r.objects(UsersPlaceModel.self).first
        
        let orderManager = OrderManager(checkinUID: oldCheckin, tableUID: tableUID, placeUID: place!.placeUid, userUID: "")
        
        orderManager.Move(toCheckinUID: newCheckin, data: [object.MenuItemUID]) { error in
            failure()
            print("*** addTableOrderItem 3")
        } completitionSuccess: {
            finish()
            print("*** addTableOrderItem 4")
        }
    }
    
    func fireOrderItems(orderItemUID: String, checkinUID: String, success: @escaping () -> (), failure: @escaping (String) -> ())
    {
        guard let r = DB.shared.getRealm, let tableUID = _data.first?.TableUID else {
            print("*** fireOrderItems 2")
            failure("INTERNAL_ERROR")
            return
        }
        
        let place = r.objects(UsersPlaceModel.self).first
        
        print("*** TableInteractor fireOrderItems 3")
        
        let user = r.objects(UserModel.self).first
        
        let orderManager = OrderManager(checkinUID: checkinUID, tableUID: tableUID, placeUID: place!.placeUid, userUID: user!.userUid)
        
//        let payload: [String: Any] = [
//            "comment": "",
//            "item_uid": menuItemUID,
//            "modifications": [],
//            "priority": 0,
//            "uid": UUID().uuidString
//          ]
//
        orderManager.Fire(data: [orderItemUID]) { error in
            failure(error)
        } completitionSuccess: {
            success()
        }
    }
    
    func AddNewOrderItemToCheckin(menuItemUID: String, checkinUID: String, success: @escaping () -> (), failure: @escaping (String) -> ())
    {
        guard let r = DB.shared.getRealm, let tableUID = _data.first?.TableUID else {
            print("*** sendOrderItemsToConfirm 2")
            failure("INTERNAL_ERROR")
            return
        }
        
        let place = r.objects(UsersPlaceModel.self).first

        var user = r.objects(UserModel.self).first
        
        let orderManager = OrderManager(checkinUID: checkinUID, tableUID: tableUID, placeUID: place!.placeUid, userUID: user!.userUid)
        
        let payload: [String: Any] = [
            "comment": "",
            "item_uid": menuItemUID,
            "modifications": [],
            "priority": 0,
            "uid": UUID().uuidString
          ]
        
        orderManager.New(data: [payload]) { error in
            failure(error)
        } completitionSuccess: {
            success()
        }
    }
    
    func sendOrderItemsToConfirm(data: [AnyOrderItem], success: @escaping () -> (), failure: @escaping () -> ())
    {
        print("*** TableInteractor sendOrderItemsToConfirm 1")
        
        guard let r = DB.shared.getRealm, let tableUID = _data.first?.TableUID else {
            print("*** sendOrderItemsToConfirm 2")
            failure()
            return
        }
        
        var user = r.objects(UserModel.self).first
        
        let place = r.objects(UsersPlaceModel.self).first
        
        print("*** TableInteractor sendOrderItemsToConfirm 3")
        
        let orderManager = OrderManager(checkinUID: "", tableUID: tableUID, placeUID: place!.placeUid, userUID: user!.userUid)
        
        var dataItems = [String]()
        
        for i in data
        {
            dataItems.append(i.OrderItemUID)
        }
        
        print("*** TableInteractor sendOrderItemsToConfirm 4")
        
        orderManager.Confirm(data: dataItems) { error in
            print("*** sendOrderItemsToConfirm 5")
            failure()
        } completitionSuccess: {
            print("*** TableInteractor sendOrderItemsToConfirm 6")            
            success()
        }

    }
    
    func GetMenuItemsByKeyword(keyword: String) -> [MenuItemModel]
    {
        guard let r = DB.shared.getRealm else {
            return [MenuItemModel]()
        }

        
        let items = r.objects(MenuItemModel.self).filter("Title CONTAINS %@ AND isRemoved = false", keyword).sorted(byKeyPath: "Title", ascending: true)
        
        print("*** GetMenuItemsByKeyword")
        print(items)
        
        return Array(items)
        
//        return [MenuItemModel]()
    }
    
    func GetMenuCategories() -> [MenuCategoryModel]
    {
        guard let r = DB.shared.getRealm else {
            return [MenuCategoryModel]()
        }
        
        let categories = r.objects(MenuCategoryModel.self).filter("isRemoved = false").sorted(byKeyPath: "SortIndex", ascending: true)
        
        return Array(categories)
    }
    
    func GetMenuItemsByCategory(CategoryUID: String) -> [MenuItemModel]
    {
        guard let r = DB.shared.getRealm else {
            return [MenuItemModel]()
        }
        
        let categories = r.objects(MenuItemModel.self).filter("CategoryUID = '\(CategoryUID)' AND isRemoved = false").sorted(byKeyPath: "Title", ascending: true)
        
        return Array(categories)
    }
    
    //---
    
    func getOrderDataByCheckinUID(checkinUID: String) -> TableOrderModel
    {
        return self._data.filter({ $0.CheckinUID == checkinUID }).first!
    }
    
    func IsNewOrderItems() -> Bool
    {
        return self._getCountItemsByStatus("new") > 0
    }
    
    func IsOnlyConfirmedOrderItems() -> Bool
    {
        return self._getCountItemsByStatus("active") > 0
    }
    
    private func _getCountItemsByStatus(_ status: String) -> Int
    {
        return _data.reduce(0) { $0 + $1.Items.filter({ $0.Status == status }).count }
    }
    
    func IfInCheckinUID(_ chekinUID: String) -> Bool
    {
        if(self._data.count == 0)
        {
            return false
        }
        
        return self._data.filter({ $0.CheckinUID == chekinUID }).count > 0
    }
    
    func IfTableUID(_ tableUID: String) -> Bool
    {
        return tableUID == _tableUID
    }
    
    func GetTable() -> TableModel?
    {
        guard let r = DB.shared.getRealm, let table = r.objects(TableModel.self).filter("uid = '\(self._tableUID)'").first else {
            return nil
        }
        
        return table
    }
    
    func ReloadData()
    {
        _initData()
    }
    
    func getData() -> [TableOrderModel]
    {
        return _data
    }
    

}
