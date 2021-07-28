//
//  MainPresenter.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation

final class TablePresenter
{        
    // MARK: - Private properties -
    
    private var _readyToConfirm = [AnyOrderItem]()
    
    private var _dataMenu = [SeatsMenuItemModel]()

    private unowned let view: TableViewProtocol
    
    private let interactor: TableInteractorProtocol
    
    private let wireframe: TableWireframeProtocol

    // MARK: - Lifecycle -

    init(view: TableViewProtocol, interactor: TableInteractorProtocol, wireframe: TableWireframeProtocol)
    {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        
        _initBaseData()
    }
    
    func _initBaseData()
    {
//        print("*** TablePresenter _initBaseData 1")
        
        let cats = self.interactor.GetMenuCategories()
        
        _dataMenu = [SeatsMenuItemModel]()
        
        for item in cats
        {
            let newItem = SeatsMenuItemModel()
            
            newItem.CategoryUID = ""
            newItem.PhotoURI = item.PhotoURI
            newItem.Price = 0
            newItem.SortIndex = 0
            newItem.Title = item.Title
            newItem.Type = .Category
            newItem.UID = item.UID
            
            _dataMenu.append(newItem)
        }
        
//        print("*** TablePresenter _initBaseData 2 COUNT \(_dataMenu.count)")
    }
}


// MARK: - Extensions -
extension TablePresenter: TablePresenterProtocol
{
    func RemoveOrderItem(orderItemUID: String, checkinUID: String, beforeExternelRemove: @escaping () -> (), success: @escaping () -> (), failure: @escaping (_ error: String) -> ())
    {
        
        print("*** RemoveOrderItem *** \(orderItemUID)")
//        self.interactor.RemoveOrderItem(orderItemUID: orderItemUID, checkinUID: checkinUID)
//        {
//            beforeExternelRemove()
//        }
        
        self.interactor.RemoveOrderItem(orderItemUID: orderItemUID, checkinUID: checkinUID) {
            print("*** RemoveOrderItem *** 2")
            beforeExternelRemove()
        } success: {
            print("*** RemoveOrderItem *** 3")
            success()
        } failure: { error in
            print("*** RemoveOrderItem *** 4")
            failure(error)
        }

    }
    
    func RestoreOrderItem(orderItemUID: String, checkinUID: String, beforeExternelRemove: @escaping () -> ())
    {
        self.interactor.RestoreOrderItem(orderItemUID: orderItemUID, checkinUID: checkinUID)
        {
            beforeExternelRemove()
        }
    }
        
    func getTableUID() -> String
    {
        return self.interactor.getTableUID()
    }
    
    func getPlaceCurrency() -> String
    {
        return self.interactor.getPlaceCurrency()
    }
    
    func removeTableOrderItem(order: Int, item: Int)
    {
        self.interactor.removeTableOrderItem(order: order, item: item)
    }
    
    func addTableOrderItem(object: TableOrderItemModel, order: Int, item: Int, finish: @escaping () -> (), failure: @escaping () -> ())
    {
//        self.interactor.addTableOrderItem(object: object, order: order, item: item)
        
        self.interactor.addTableOrderItem(object: object, order: order, item: item) {
            finish()
        } failure: {
            failure()
        }

    }
    
    func GoToMenuItemDetails(uid: String)
    {
        self.wireframe.GoToMenuItemDetails(uid: uid)
    }
    
    func fireOrderItems(orderItemUID: String, checkinUID: String, success: @escaping () -> (), failure: @escaping (String) -> ())
    {
        self.interactor.fireOrderItems(orderItemUID: orderItemUID, checkinUID: checkinUID) {
            success()
        } failure: { error in
            failure(error)
        }
    }
    
    func AddNewOrderItemToCheckin(menuItemUID: String, checkinUID: String, success: @escaping () -> (), failure: @escaping (String) -> ())
    {
        self.interactor.AddNewOrderItemToCheckin(menuItemUID: menuItemUID, checkinUID: checkinUID) {
            success()
        } failure: { error in
            failure(error)
        }
    }
    
    func sendOrderItemsToConfirm(success: @escaping () -> (), failure: @escaping (_ error: String) -> ())
    {
        print("*** TablePresenter sendOrderItemsToConfirm 1")
        
        var readyToConfirm = [AnyOrderItem]()
        
        let data = self.interactor.getData()

        for i in data
        {
            for i2 in i.Items.filter({ $0.Status == "new" })
            {
                let a = AnyOrderItem(checkinUID: i.CheckinUID, orderItemUID: i2.OrderItemUID)
                readyToConfirm.append(a)
            }   
        }
        
        if(readyToConfirm.count == 0)
        {
            failure("Nothing to send")
            return
        }
        
//        if(_readyToConfirm.count == 0)
//        {
//            print("*** TablePresenter sendOrderItemsToConfirm 2")
//
//            failure("Nothing to send")
//            return
//        }
//
        print("*** TablePresenter sendOrderItemsToConfirm 3")

        self.interactor.sendOrderItemsToConfirm(data: readyToConfirm)
        {
            print("*** TablePresenter sendOrderItemsToConfirm 4")
            
            success()
        } failure: {
            print("*** TablePresenter sendOrderItemsToConfirm 5")
            
            failure("INTERNAL_ERROR")
        }
    }
    
    func clearOrderItemsReadyToConfirm()
    {
        _readyToConfirm = [AnyOrderItem]()
    }
    
    func addOrderItemToReadyToConfirm(orderItemUID: String, checkinUID: String)
    {
        _readyToConfirm.append(AnyOrderItem(checkinUID: checkinUID, orderItemUID: orderItemUID))
    }
    
    func removeOrderItemToReadyToConfirm(orderItemUID: String, checkinUID: String)
    {
        if let idx = _readyToConfirm.firstIndex(where: { $0.OrderItemUID == orderItemUID })
        {
            _readyToConfirm.remove(at: idx)
        }
    }
    
    func getOrderItemsReadyToConfirm() -> [AnyOrderItem]
    {
        return _readyToConfirm
    }
    
    //----
    
    func getMenuItemsCount() -> Int
    {
//        print("*** TablePresenter getMenuItemsCount")
        return _dataMenu.count
    }
    
    func ReloadMenuCategories()
    {
        print("*** TablePresenter ReloadMenuCategories")
        
        _initBaseData()
    }
    
    func getMenuDataItem(idx: Int) -> SeatsMenuItemModel
    {
//        print("*** TablePresenter getMenuDataItem")
        
        return self._dataMenu[idx]
    }
    
    func ReloadMenuByKeyword(keyword: String)
    {
        let items = self.interactor.GetMenuItemsByKeyword(keyword: keyword)
        
        _dataMenu = [SeatsMenuItemModel]()
        
        for item in items
        {
            let newItem = SeatsMenuItemModel()
            
            newItem.CategoryUID = ""
            newItem.PhotoURI = item.PhotoURI
            newItem.Price = 0
            newItem.SortIndex = 0
            newItem.Title = item.Title
            newItem.Type = .Item
            newItem.UID = item.UID
            
            _dataMenu.append(newItem)
        }
    }
    
    
    func ReloadMenuCategoryItems(categoryUID: String)
    {
//        print("*** TablePresenter ReloadMenuCategoryItems")
        
        let items = self.interactor.GetMenuItemsByCategory(CategoryUID: categoryUID)
        
        _dataMenu = [SeatsMenuItemModel]()
        
        for item in items
        {
            let newItem = SeatsMenuItemModel()
            
            newItem.CategoryUID = ""
            newItem.PhotoURI = item.PhotoURI
            newItem.Price = 0
            newItem.SortIndex = 0
            newItem.Title = item.Title
            newItem.Type = .Item
            newItem.UID = item.UID
            
            _dataMenu.append(newItem)
        }
    }
    
    //----
    
    func IsNewOrderItems() -> Bool
    {
        return self.interactor.IsNewOrderItems()
    }
    
    func IsOnlyConfirmedOrderItems() -> Bool
    {
        return self.interactor.IsOnlyConfirmedOrderItems()
    }
    
    func IfInCheckinUID(_ chekinUID: String) -> Bool
    {
        return self.interactor.IfInCheckinUID(chekinUID)
    }
    
    func IfTableUID(_ tableUID: String) -> Bool
    {
        return self.interactor.IfTableUID(tableUID)
    }
    
    func GetTableName() -> String
    {
        guard let table = self.interactor.GetTable() else {
            return "Table not found"
        }
        
        if(!table.partyName.isEmpty)
        {
            return "Party name: \(table.partyName)"
        }
        
        return "Table #\(table.parameters.number)"
    }
    
    func ReloadData()
    {
        self.interactor.ReloadData()
    }
    
    func GetTotalOrdersAmount() -> Double
    {
        return self.interactor.getData().reduce(0) { $0 + $1.TotalAmount }
    }
    
    func getTableOrderItem(order: Int, item: Int) -> TableOrderItemModel
    {
        return self.interactor.getData()[order].Items[item]
    }
    
    func getOrderDataByCheckinUID(checkinUID: String) -> TableOrderModel
    {
        return self.interactor.getOrderDataByCheckinUID(checkinUID: checkinUID)
    }
    
    func getOrderItemDataByUID(orderItemUID: String, checkinUID: String) -> TableOrderItemModel
    {
        let data = self.interactor.getOrderDataByCheckinUID(checkinUID: checkinUID)
        
        return data.Items.filter({ $0.OrderItemUID == orderItemUID }).first!
    }
    
    func getOrderData(order: Int) -> TableOrderModel
    {
        if(!self.interactor.getData().indices.contains(order))
        {
            return TableOrderModel()
        }
        
        return self.interactor.getData()[order]
    }
    
    func GetTotalAmount() -> Double
    {
        return 0
    }
    
    func GetTableCurrency() -> String
    {
        return "$"
    }
    
    func GoBack()
    {
        self.wireframe.GoBack()
    }
    
    func GoToMap()
    {
        self.wireframe.GoToMap()
    }
    
    func getOrdersCount() -> Int
    {
        return self.interactor.getData().count
    }
    
    func getOrderItemsCount(order: Int) -> Int
    {
        return self.interactor.getData()[order].Items.count
    }
    
    func getData() -> [TableOrderModel]
    {
        return self.interactor.getData()
    }
    
    /// Метод для добавления фейкового TableOrderItemModel
    /// - Parameters:
    ///   - section: Индекс секции (в нашем случае позиция заказов гостя в списке)
    ///   - orderItem: TableOrderItemModel с параметром itemDraggableType = availableToDrop
    func addFakeOrderItem(section: Int, orderItem: TableOrderItemModel)
    {
        if (orderItem.itemDraggableType == .availableToDrop) {
            self.interactor.getData()[section].Items.append(orderItem)
        }
    }
    
    func fakeOrderItems(section: Int) -> [IndexPath]
    {
        var removeItems = [IndexPath]()
        for item in 0 ..< self.interactor.getData()[section].Items.count {
            switch self.interactor.getData()[section].Items[item].itemDraggableType {
            case .availableToDrop: removeItems.append(IndexPath(item: item, section: section))
            case .simple: break
            }
        }
        removeItems.forEach { self.interactor.getData()[$0.section].Items.remove(at: $0.item) }
        return removeItems
    }
    
    func removeOrderItem(in section: Int, at index: Int) {
        if (self.interactor.getData()[section].Items.safety(at: index) != nil) {
            self.interactor.getData()[section].Items.remove(at: index)
        }
        
        self.interactor.getData()[section].Items.removeAll()
    }
    
    func insertOrderItem(orderItem:TableOrderItemModel, in section: Int, at index: Int) {
        if (self.interactor.getData()[section].Items.count > index) {
            self.interactor.getData()[section].Items.insert(orderItem, at: index)
        }
    }
    
    func reorderOrderItem(fromSection sectionFrom: Int, fromIndex indexFrom: Int, toSection sectionTo: Int, toIndex indexTo: Int) {
        if (sectionFrom == sectionTo) {
            self.interactor.getData()[sectionFrom].Items.move(from: indexFrom, to: indexTo)
        }
        else {
            if let orderItem:TableOrderItemModel = self.interactor.getData()[sectionFrom].Items.safety(at: indexFrom) {
                self.interactor.getData()[sectionFrom].Items.remove(at: indexFrom)
                self.interactor.getData()[sectionTo].Items.insert(orderItem, at: indexTo)
            }
        }
    }
}
