//
//  MapProtocols.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

protocol MapWireframeProtocol: WireframeProtocol
{
    func switchToUserProfileController()
    
    func switchToOrdersController()
    
    func openTable(tableUid: String)
    
    func openSeats(tableUid: String)
}

protocol MapViewProtocol: ViewProtocol
{

}

protocol MapPresenterProtocol: PresenterProtocol
{
    func GetID() -> String
    
    func getButtonDeleteId() -> Int
    
    func deleteTables(uids: [String],
                     completitionSuccess: @escaping () -> (),
                     completitionWithError: @escaping (_ error: String) -> ())
    
    func saveTables(data: [TableView],
                    completitionSuccess: @escaping () -> (),
                    completitionWithError: @escaping (_ error: String) -> ())
    
    func setModeEdit()
    
    func setModeNormal()
    
    func getMode() -> MapMode
    
    func getEmptyTableByType(type: String) -> TableModel
    
    func getOrdersCount() -> Int
    
    func getOorderAmount() -> Double
    
    func getPlaceCurrency() -> String
    
    func GoToOrders()
    
    func GoToProfile()
    
    func switchToUserProfileController()
    
    func switchToOrdersController()
    
    func openTable(tableUid: String)
    
    func openSeats(tableUid: String)
    
    func storeCode(_ code: Int, tableUid: String)
    
    func getPlace() -> String
    
    func getCode(table: TableModel) -> Bool
    
    func getTables(placeUid: String, forced: Bool) -> [TableModel]
    
    func getCheckins() -> [CheckinModel]
    
    func getCheckin(tableUid: String, checkinUid: String) -> CheckinModel?
    
    func getTable(uid: String) -> TableModel?
    
    func getCode(table: String, completion: @escaping ((Int)?) -> ())
}

protocol MapInteractorProtocol: InteractorProtocol
{
    func getCode(table: String, completion: @escaping ((Int)?) -> ())
    
    func getPlaceCurrency() -> String
    
    func getTable(uid: String) -> TableModel?
    
    func saveTablePosition(uid: String, x: Float, y: Float, rotation: Float)
    
    func setTablesAsRemoved(uids: [String])
    
    func deleteTables(uids: [String],
                     completitionSuccess: @escaping () -> (),
                     completitionWithError: @escaping (_ error: String) -> ())
    
    func saveTables(data: [Any],
                    completitionSuccess: @escaping () -> (),
                    completitionWithError: @escaping (_ error: String) -> ())
    
    func storeCode(_ code: Int, tableUid: String)
    
    func getPlace() -> String
    
    func getCode(table: TableModel) -> Bool
    
    func getTables(placeUid: String, forced: Bool) -> [TableModel]
    
    func getCheckins() -> [CheckinModel]
    
    func getCheckin(tableUid: String, checkinUid: String) -> CheckinModel?
    
    func getOrdersCount() -> Int
    
    func getOorderAmount() -> Double
}
