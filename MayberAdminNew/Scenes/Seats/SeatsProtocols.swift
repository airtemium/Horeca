//
//  MainProtocols.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

protocol SeatsWireframeProtocol: WireframeProtocol
{
    func BackToMap()
    
    func switchToTable()
    
    func GoToMenuItemDetails(uid: String)
}

protocol SeatsViewProtocol: ViewProtocol {

}

protocol SeatsPresenterProtocol: PresenterProtocol
{
    func GoToMenuItemDetails(uid: String)
    
    func getMenuItemsCount() -> Int
    
    func ReloadCategories()
    
    func getDataItem(idx: Int) -> SeatsMenuItemModel
    
    func ReloadCategoryItems(categoryUID: String)
    
    func getTableName() -> String
    
    func getTableCode() -> String
    
    func getTotalOrdersAmount() -> Double
    
    func getTable() -> TableModel?
    
    func getTableCheckins() -> [CheckinModel]
    
    func BackToMap()
    
    func ReloadMenuByKeyword(keyword: String)
    
    func switchToTable()
    
    func getOrderItemsByCheckin(checkinUID: String) -> [OrderItemModel]
    
    func addMenuItemToCheckin(checkinUID: String, menuItemUID: String, success: @escaping  () -> (), failure: @escaping  () -> ())
    
    func getTableUID() -> String
    
    func ReloadData()
    
    func IfInCheckinUID(_ checkin_uid: String) -> Bool
    
    func getMenuItem(menuItemUID: String) -> MenuItemModel?
    
    func getCode(table: String, completion: @escaping ((Int)?) -> ())
    
    func createCheckin(guest_number: Int, table_code: Int, finishSuccess: @escaping (_ checkinUID: String) -> (), failure: @escaping (_ error: String) -> ())
    
    func getPlaceCurrency() -> String
    
    func getMenuItemPrice(uid: String) -> Double
    
    func getMenuItemTitle(uid: String) -> String
    
    func getCheckinColorByNumber(number: Int) -> UIColor
        
    func ReloadDrinksCategory()
}

protocol SeatsInteractorProtocol: InteractorProtocol
{
    func getMenuItemTitle(uid: String) -> String
    
    func getMenuItemPrice(uid: String) -> Double
    
    func getPlaceCurrency() -> String
    
    func getCode(table: String, completion: @escaping ((Int)?) -> ())
    
    func getTableCode() -> String
    
    func addMenuItemToCheckin(checkinUID: String, menuItemUID: String, success: @escaping  () -> (), failure: @escaping  () -> ())
    
    func GetMenuItemsByKeyword(keyword: String) -> [MenuItemModel]
    
    func GetMenuCategories(type: String) -> [MenuCategoryModel]
    
    func GetMenuItemsByCategory(CategoryUID: String) -> [MenuItemModel]
    
    func getTableName() -> String
    
    func getTotalOrdersAmount() -> Double
    
    func getTable() -> TableModel?
    
    func getTableCheckins() -> [CheckinModel]
    
    func getOrderItemsByCheckin(checkinUID: String) -> [OrderItemModel]
    
    func getTables() -> [TableModel]
    
    func getOrderItems() -> [OrderItemModel]
    
    func getTableUID() -> String
    
    func getMenuItem(menuItemUID: String) -> MenuItemModel?
    
    func createCheckin(guest_number: Int, table_code: Int, finishSuccess: @escaping (_ checkinUID: String) -> (), failure: @escaping (_ error: String) -> ())
    
//    func createCheckinForGuestNumber(guestNumber: Int)
}


