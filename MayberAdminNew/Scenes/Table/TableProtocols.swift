//
//  MainProtocols.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

protocol TableWireframeProtocol: WireframeProtocol
{
    func GoBack()
    
    func GoToMap()
    
    func GoToMenuItemDetails(uid: String)
}

protocol TableViewProtocol: ViewProtocol
{
    func showNotifyMoveOrderItem()
}

protocol TablePresenterProtocol: PresenterProtocol
{
    func getPlaceCurrency() -> String
        
    func removeTableOrderItem(order: Int, item: Int)
    
    func addTableOrderItem(object: TableOrderItemModel, order: Int, item: Int, finish: @escaping () -> (), failure: @escaping () -> ())
    
    //---
    
    func getData() -> [TableOrderModel]
    
    func getOrderData(order: Int) -> TableOrderModel
    
    func getOrdersCount() -> Int
    
    func getOrderItemsCount(order: Int) -> Int
    
    func GoBack()
    
    func GoToMap()
    
    func GoToMenuItemDetails(uid: String)
    
    func GetTotalAmount() -> Double
    
    func GetTableCurrency() ->  String
    
    func GetTotalOrdersAmount() -> Double
    
    func ReloadData()
    
    func GetTableName() -> String
    
    func IfTableUID(_ tableUID: String) ->  Bool
    
    func IfInCheckinUID(_ chekinUID: String) -> Bool
    
    func getTableOrderItem(order: Int, item: Int) -> TableOrderItemModel
    
    func IsNewOrderItems() -> Bool
    
    func IsOnlyConfirmedOrderItems() -> Bool
    
    func getOrderDataByCheckinUID(checkinUID: String) -> TableOrderModel
    
    //--
    
    
    func getMenuItemsCount() -> Int
    
    func ReloadMenuCategories()
    
    func getMenuDataItem(idx: Int) -> SeatsMenuItemModel
    
    func ReloadMenuCategoryItems(categoryUID: String)
    
    func ReloadMenuByKeyword(keyword: String)
    
    //---
    
    func addOrderItemToReadyToConfirm(orderItemUID: String, checkinUID: String)
    
    func removeOrderItemToReadyToConfirm(orderItemUID: String, checkinUID: String)
    
    func getOrderItemsReadyToConfirm() -> [AnyOrderItem]
    
    func clearOrderItemsReadyToConfirm()
    
    func fireOrderItems(orderItemUID: String, checkinUID: String, success: @escaping () -> (), failure: @escaping (_ error: String) -> ())
    
    func sendOrderItemsToConfirm(success: @escaping () -> (), failure: @escaping (_ error: String) -> ())
    
    func AddNewOrderItemToCheckin(menuItemUID: String, checkinUID: String, success: @escaping () -> (), failure: @escaping (_ error: String) -> ())
    
    func getOrderItemDataByUID(orderItemUID: String, checkinUID: String) -> TableOrderItemModel
    
    func getTableUID() -> String
    
    /// Метод для добавления фейкового TableOrderItemModel
    /// - Parameters:
    ///   - section: Индекс секции (в нашем случае позиция заказов гостя в списке)
    ///   - orderItem: TableOrderItemModel с параметром itemDraggableType = availableToDrop
    func addFakeOrderItem(section: Int, orderItem: TableOrderItemModel)

    
    /// Метод удаляет фейковые модели и возвращает массив IndexPath
    /// Для удаления соответствующих ячеек в коллекции
    /// - Parameter section: Индекс секции
    func fakeOrderItems(section: Int) -> [IndexPath]
    
    func removeOrderItem(in section: Int, at index: Int)
    
    func insertOrderItem(orderItem:TableOrderItemModel, in section: Int, at index: Int)
    
    func reorderOrderItem(fromSection sectionFrom: Int, fromIndex indexFrom: Int, toSection sectionTo: Int, toIndex indexTo: Int)
    
    func RemoveOrderItem(orderItemUID: String, checkinUID: String, beforeExternelRemove: @escaping () -> (), success: @escaping () -> (), failure: @escaping (_ error: String) -> ())
    
    func RestoreOrderItem(orderItemUID: String, checkinUID: String, beforeExternelRemove: @escaping () -> ())
}

protocol TableInteractorProtocol: InteractorProtocol
{
    func RestoreOrderItem(orderItemUID: String, checkinUID: String, beforeExternelRemove: @escaping () -> ())
    
    func RemoveOrderItem(orderItemUID: String, checkinUID: String, beforeExternelRemove: @escaping () -> (), success: @escaping () -> (), failure: @escaping (_ error: String) -> ())
    
    func getPlaceCurrency() -> String
    
    func removeTableOrderItem(order: Int, item: Int)
    
    func addTableOrderItem(object: TableOrderItemModel, order: Int, item: Int, finish: @escaping () -> (), failure: @escaping () -> ())
    
    func AddNewOrderItemToCheckin(menuItemUID: String, checkinUID: String, success: @escaping () -> (), failure: @escaping (_ error: String) -> ())
    
    func sendOrderItemsToConfirm(data: [AnyOrderItem], success: @escaping () -> (), failure: @escaping () -> ())
    
    func fireOrderItems(orderItemUID: String, checkinUID: String, success: @escaping () -> (), failure: @escaping (_ error: String) -> ())
    
    func getOrderDataByCheckinUID(checkinUID: String) -> TableOrderModel
    
    func IsNewOrderItems() -> Bool
    
    func IsOnlyConfirmedOrderItems() -> Bool
    
    func getData() -> [TableOrderModel]
    
    func ReloadData()
    
    func getTableUID() -> String
    
    func GetTable() -> TableModel?
    
    func IfTableUID(_ tableUID: String) ->  Bool
    
    func IfInCheckinUID(_ chekinUID: String) -> Bool
    
    //---
    
    func GetMenuCategories() -> [MenuCategoryModel]
    
    func GetMenuItemsByCategory(CategoryUID: String) -> [MenuItemModel]
    
    func GetMenuItemsByKeyword(keyword: String) -> [MenuItemModel]
}
