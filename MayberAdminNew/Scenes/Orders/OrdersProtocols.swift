//
//  MainProtocols.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

protocol OrdersWireframeProtocol: WireframeProtocol
{
    func OpenTable(tableUID: String, prev: String)
    
    func SwitchTomap()
    
    func SwitchToProfile()
}

protocol OrdersViewProtocol: ViewProtocol
{

}

protocol OrdersPresenterProtocol: PresenterProtocol
{
    func SwitchToProfile()
    
    func SwitchTomap()
    
    func getOrdersCount() -> Int
    
    func getOorderAmount() -> Double
    
    func getPlaceCurrency() -> String
    
    func getDataItem(idx: Int) -> TableOrders
    
    func OpenTable(tableUID: String, prev: String)
    
    func reloadOrders()
    
    func getCheckinsCount() -> Int
    
    func CloseCheckinsAsPaidByTableUID(tableUID: String, leftUnpaid: Bool, payedByCash: Bool, comment: String, finishWithSuccess: @escaping () -> (), finishWithError: @escaping () -> ())
}

protocol OrdersInteractorProtocol: InteractorProtocol
{
    func getPlaceCurrency() -> String
    
    func getOrderItems() -> [OrderItemModel]
    
    func getCheckins() -> [CheckinModel]
    
    func SetInvoiceStatus(payload: [String: Any], finish: @escaping () -> ())
    
    func InvoicesCancel(payload: [String: Any], finish: @escaping () -> ())
    
    func getTables() -> [TableModel]
    
    func getUserUID() -> String
    
    func PayCheckins(data: [String: Any],
                     completitionSuccess: @escaping (_ checkinUID: String) -> (),
                     completitionWithError: @escaping (_ error: String) -> ())
    
    func getOrderItemsByCheckin(checkinUID: String) -> [OrderItemModel]
    
    func CloseCheckinsAsPaidByTableUID(tableUID: String, finishWithSuccess: @escaping () -> (), finishWithError: @escaping () -> ())
}
