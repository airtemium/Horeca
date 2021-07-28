//
//  MainPresenter.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation

final class SeatsPresenter
{
    private var _dataMenu = [SeatsMenuItemModel]()
    
    private var _data = [TableOrders]()
    
    private var _checkins = [CheckinModel]()
    
    // MARK: - Private properties -

    private unowned let view: SeatsViewProtocol
    
    private let interactor: SeatsInteractorProtocol
    
    private let wireframe: SeatsWireframeProtocol
    
    private var _currentMenuType = SeatsMenuItemType.Category

    // MARK: - Lifecycle -

    init(view: SeatsViewProtocol, interactor: SeatsInteractorProtocol, wireframe: SeatsWireframeProtocol)
    {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        
        _initBaseData()
        
        _reloadData()
    }
    
    private func _reloadData()
    {
        guard let r = DB.shared.getRealm, let place = r.objects(UsersPlaceModel.self).first else {
            return
        }
        
        var data = [TableOrders]()
        
        _checkins = self.interactor.getTableCheckins()
        
        let tables = self.interactor.getTables()
        
//        var orderItems = self.interactor.getOrderItems()
        
        for item in tables
        {
            let tableChekins = _checkins.filter({ $0.tableUid == item.uid })
            
//            var tableOrderItems = orderItems.filter({ $0. })
            
            if(tableChekins.count == 0)
            {
                continue
            }
            
            let total = tableChekins.reduce(0) { $0 + $1.total }
            
            let table1 = TableOrders()
            table1.AmountTotal = total
            table1.TableUID = item.uid
            table1.AmountTotalCurrency = place.Currency
            table1.GuestCount = tableChekins.count
            table1.PartyName = item.partyName
            table1.Status = ""
            table1.TableNumber = item.parameters.number

            data.append(table1)
        }

        _data = data.sorted(by: { $0.TableNumber < $1.TableNumber })
    }
    
    func _initBaseData(force: Bool = true)
    {
        if(force)
        {
            _currentMenuType = SeatsMenuItemType.Category
        }
        
        let type = "ALL"

        let cats = self.interactor.GetMenuCategories(type: type)
        
        _dataMenu = [SeatsMenuItemModel]()
        

        let newItem = SeatsMenuItemModel()
        newItem.CategoryUID = ""
        newItem.PhotoURI = ""
        newItem.Price = 0
        newItem.SortIndex = 0
        newItem.Title = "DRINKS"
        newItem.Type = .DrinkCategory
        newItem.UID = "DRINKS"
        _dataMenu.append(newItem)
        
                
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
            newItem.MenuItemType = type
            
            _dataMenu.append(newItem)
        }
    }
}

// MARK: - Extensions -
extension SeatsPresenter: SeatsPresenterProtocol
{

    
    func getCheckinColorByNumber(number: Int) -> UIColor
    {
        switch(number)
        {
        case 1, 9, 10, 11, 12, 13, 14:
            return UIColor(red: 37/255, green: 70/255, blue: 119/255, alpha: 1)
        case 2:
            return UIColor(red: 51/255, green: 140/255, blue: 80/255, alpha: 1)//rgb 51 140 80
        case 3:
            return UIColor(red: 220/255, green: 151/255, blue: 52/255, alpha: 1)//rgb 220 151 52
        case 4:
            return UIColor(red: 169/255, green: 25/255, blue: 25/255, alpha: 1)//rgb 169 25 25
        case 5:
            return UIColor(red: 110/255, green: 62/255, blue: 186/255, alpha: 1)//rgb 110 62 186
        case 6:
            return UIColor(red: 17/255, green: 140/255, blue: 190/255, alpha: 1)//rgb 17 140 190
        case 7:
            return UIColor(red: 192/255, green: 8/255, blue: 155/255, alpha: 1)//rgb 192 8 155
        case 8:
            return UIColor(red: 228/255, green: 92/255, blue: 60/255, alpha: 1)//rgb 228 92 60
        default:
            return .purple
        }
    }
    
    func getMenuItemPrice(uid: String) -> Double
    {
        return self.interactor.getMenuItemPrice(uid: uid)
    }
    
    func getMenuItemTitle(uid: String) -> String
    {
        return self.interactor.getMenuItemTitle(uid: uid)
    }
    
    func getPlaceCurrency() -> String
    {
        return self.interactor.getPlaceCurrency()
    }
    
    func createCheckin(guest_number: Int, table_code: Int, finishSuccess: @escaping (String) -> (), failure: @escaping (String) -> ())
    {
        self.interactor.createCheckin(guest_number: guest_number, table_code: table_code) { checkin in
            finishSuccess(checkin)
        } failure: { error in
            failure(error)
        }
    }
    
    func getCode(table: String, completion: @escaping ((Int)?) -> ())
    {
        self.interactor.getCode(table: table) { code in
            completion(code)
        }
    }
    
    func getTableCode() -> String
    {
        self.interactor.getTableCode()
    }
    
    func getMenuItem(menuItemUID: String) -> MenuItemModel?
    {
        return self.interactor.getMenuItem(menuItemUID: menuItemUID)
    }
    
    func IfInCheckinUID(_ checkin_uid: String) -> Bool
    {
        return _checkins.contains(where: { $0.checkinUid == checkin_uid })
    }
    
    func ReloadData()
    {
        self._reloadData()
    }
    
    func getTableUID() -> String
    {
        return self.interactor.getTableUID()
    }
    
    func addMenuItemToCheckin(checkinUID: String, menuItemUID: String, success: @escaping () -> (), failure: @escaping () -> ())
    {
//        self.interactor.addMenuItemToCheckin(checkinUID: checkinUID, menuItemUID: menuItemUID)
        
        self.interactor.addMenuItemToCheckin(checkinUID: checkinUID, menuItemUID: menuItemUID) {
            success()
        } failure: {
            failure()
        }
    }

    func getOrderItemsByCheckin(checkinUID: String) -> [OrderItemModel]
    {
        return self.interactor.getOrderItemsByCheckin(checkinUID: checkinUID)
    }
    
    func GoToMenuItemDetails(uid: String)
    {
        self.wireframe.GoToMenuItemDetails(uid: uid)
    }
    
    func switchToTable()
    {
        self.wireframe.switchToTable()
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
    
    func BackToMap()
    {
        self.wireframe.BackToMap()
    }
    
    func ReloadDrinksCategory()
    {
        _currentMenuType = SeatsMenuItemType.DrinkCategory
        
        let cats = self.interactor.GetMenuCategories(type: "DRINKS")
        
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
    }
    
    func ReloadCategoryItems(categoryUID: String)
    {
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
    
    func getDataItem(idx: Int) -> SeatsMenuItemModel
    {
        _dataMenu[idx]
    }
    
    func ReloadCategories()
    {
        if(_currentMenuType == .DrinkCategory)
        {
            ReloadDrinksCategory()
            
            _currentMenuType = .Category
        }
        else
        {
            _initBaseData(force: true)
        }
        
    }
    
    func getMenuItemsCount() -> Int
    {
        _dataMenu.count
    }
    
    func getTableName() -> String
    {
        interactor.getTableName()
    }
    
    func getTotalOrdersAmount() -> Double
    {
        _data.reduce(0) { $0 + $1.AmountTotal }
    }
    
    func getTable() -> TableModel?
    {
        interactor.getTable()
    }
    
    func getTableCheckins() -> [CheckinModel]
    {
//        print("*** SeatsPresenter getTableCheckins *** \(_checkins.count)")
        return _checkins
    }
}
