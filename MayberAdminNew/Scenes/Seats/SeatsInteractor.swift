//
//  MainInteractor.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import Alamofire

final class SeatsInteractor {
    
    private var _tableUid: String = ""
    
    private var _table: TableModel!
    
    private var _checkins: [CheckinModel]!
    
    private var _data = [TableOrderModel]()
    
    private var _currency = ""
    
    init(tableUid: String)
    {
        _tableUid = tableUid
        
        _initData()
    }
    
    func _initData()
    {
//        Logger.logDebug("TableUid: \(_tableUid)")
    }
}

// MARK: - Extensions -

extension SeatsInteractor: SeatsInteractorProtocol
{
    func getMenuItemTitle(uid: String) -> String
    {
        guard let r = DB.shared.getRealm, let item = r.objects(MenuItemModel.self).filter("UID = '\(uid)'").first else {
            return ""
        }
        
        return item.Title
    }
    
    func getMenuItemPrice(uid: String) -> Double
    {
        guard let r = DB.shared.getRealm, let item = r.objects(MenuItemModel.self).filter("UID = '\(uid)'").first else {
            return 0
        }
        
        return item.Price
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
    
    func getTableCode() -> String
    {
        guard let table = getTable() else {
            return "Table not found"
        }
        
        return String(table.code)
    }
    
    func getTableUID() -> String
    {
        return self._tableUid
    }
    
    func addMenuItemToCheckin(checkinUID: String, menuItemUID: String, success: @escaping () -> (), failure: @escaping () -> ())
    {
//        guard let tableUID = _data.first?.TableUID else {
//            print("*** SeatsInteractor sendOrderItemsToConfirm 2")
//            return
//        }
        
        guard let r = DB.shared.getRealm else {
            failure()
            return
        }

        
        let place = r.objects(UsersPlaceModel.self).first
        
        print("*** SeatsInteractor sendOrderItemsToConfirm 3")
        
        let user = r.objects(UserModel.self).first
        
        let orderManager = OrderManager(checkinUID: checkinUID, tableUID: self._tableUid, placeUID: place!.placeUid, userUID: user!.userUid)
        
        let payload: [String: Any] = [
            "comment": "",
            "item_uid": menuItemUID,
            "modifications": [],
            "priority": 0,
            "uid": UUID().uuidString
          ]
        
        orderManager.New(data: [payload]) { error in
            print("*** SeatsInteractor sendOrderItemsToConfirm 4")
        } completitionSuccess: {
            print("*** SeatsInteractor sendOrderItemsToConfirm 5")
        }
    }
    
    func getTables() -> [TableModel]
    {
        guard let r = DB.shared.getRealm else {
            return [TableModel]()
        }
        
        let tables = r.objects(TableModel.self)
        
        return Array(tables)
    }
    
    func getOrderItems() -> [OrderItemModel]
    {
        guard let r = DB.shared.getRealm else {
            return [OrderItemModel]()
        }
        
        let items = r.objects(OrderItemModel.self).filter("Status IN %@", ["new", "active", "ready"])
        
        return Array(items)
    }
    
    func getOrderItemsByCheckin(checkinUID: String) -> [OrderItemModel]
    {
        guard let r = DB.shared.getRealm else {
            return [OrderItemModel]()
        }
        
        let items = r.objects(OrderItemModel.self).filter("CheckinUID = '\(checkinUID)' AND Status IN %@", ["new", "active", "ready"])
        
        return Array(items)                
    }

    func GetMenuItemsByKeyword(keyword: String) -> [MenuItemModel]
    {
        guard let r = DB.shared.getRealm else {
            return [MenuItemModel]()
        }
        
        let items = r.objects(MenuItemModel.self).filter("Title CONTAINS %@ AND isRemoved = false", keyword).sorted(byKeyPath: "Title", ascending: true)
        
//        print("*** GetMenuItemsByKeyword")
//        print(items)
        
        return Array(items)
        
//        return [MenuItemModel]()
    }

    func GetMenuCategories(type: String) -> [MenuCategoryModel]
    {
        var prediction = "<>"
        
        if(type == "DRINKS")
        {
            prediction = "="
        }
        
        guard let r = DB.shared.getRealm else {
            return [MenuCategoryModel]()
        }
        
        let categories = r.objects(MenuCategoryModel.self).filter("isRemoved = false AND Type \(prediction) 'drink'").sorted(byKeyPath: "SortIndex", ascending: true)
        
        return Array(categories)
    }
    
    func getMenuItem(menuItemUID: String) -> MenuItemModel?
    {
        guard let r = DB.shared.getRealm else {
            return nil
        }
        
        guard let item = r.objects(MenuItemModel.self).filter("UID = '\(menuItemUID)'").first else {
            return nil
        }
        
        return item
    }
    
    func GetMenuItemsByCategory(CategoryUID: String) -> [MenuItemModel]
    {
        guard let r = DB.shared.getRealm else {
            return [MenuItemModel]()
        }
        
        var filter = "CategoryUID = '\(CategoryUID)' AND isRemoved = false"

        let categories = r.objects(MenuItemModel.self).filter(filter).sorted(byKeyPath: "Title", ascending: true)
        
        return Array(categories)
    }
    
    func getTableName() -> String
    {
        guard let table = getTable() else {
            return "Table not found"
        }
        
        return table.partyName.isEmpty ? "Table #\(table.parameters.number)" : "Party name: \(table.partyName)"
    }
    
    func getTotalOrdersAmount() -> Double {
        0.0
    }
    
    func getTable() -> TableModel? {
//        guard _table == nil else { return _table }
        
        guard let r = DB.shared.getRealm, let table = r.objects(TableModel.self).filter("uid = '\(self._tableUid)'").first else {
            return nil
        }
        
        return table
    }
    
    func getTableCheckins() -> [CheckinModel]
    {
//        guard _checkins == nil else { return _checkins }
        
        guard let r = DB.shared.getRealm, let table = getTable() else { return [] }
        
        let checkins = r.objects(CheckinModel.self)
            .filter("isRemoved = false AND tableUid = '\(table.uid)' AND status IN %@", ["new", "approved"])
        
        _checkins = checkins.map {$0}
        return _checkins
    }
    
    private func _saveTableCode(tableUID: String, code: Int)
    {
        guard let r = DB.shared.getRealm, let table = r.objects(TableModel.self).filter("uid = '\(tableUID)'").first else {
            return
        }
        
        try! r.write {
            table.code = code
        }
    }
    
    /*:{"guest_name":"",
     "guest_number":6,
     "place_uid":"5a493379-552d-4724-8ea9-e8880c0a72e2",
     "table_code":199},

     {"status":"SUCCESS","error_code":"","description":"","payload":{"is_geo_valid":true,"uid":"77f1beef-91e4-4fbd-bc52-fa91ed9b9183"}},
     "status_code":"200",
     "time":"2021-06-24T20:21:56.491123746Z",
     "user_uid":"vyMOrPK8eWMtDoRoqueqD5DrU2i2"}
     */

    
    func createCheckin(guest_number: Int, table_code: Int, finishSuccess: @escaping (_ checkinUID: String) -> (), failure: @escaping (_ error: String) -> ())
    {
        guard
            let r = DB.shared.getRealm,
            let serverUrl = Utils.shared.serverUrl,
            let token = r.objects(SettingsModel.self).first?.AuthToken
        else {
            failure("")
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Auth-Token": token
        ]
        
        let place = r.objects(UsersPlaceModel.self).first?.placeUid ?? ""
        
        let parameters: Parameters = [
            "guest_name": "",
            "guest_number": guest_number,
            "place_uid": place,
            "table_code": table_code
        ]
        
        let loginPath = serverUrl + "/checkin"
        
        DispatchQueue.global(qos: .utility).async {
            
            AF.request(loginPath, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseDecodable(of: ResponseModel<CheckinResponse>.self)
                { (response) in
                    switch response.result {
                    case .success(_):
                        guard let data = response.value else { return }
                                     
                        DispatchQueue.main.async {
                            finishSuccess((data.payload.uid))
                        }
                        
                        break

                    case .failure(let error):
    //                    Logger.logDebug("*** login \(error)", "")
                        
                        DispatchQueue.main.async {
                            failure(error.localizedDescription)
                        }
                        break
                    }
                }
        }
    }
    
    func getCode(table: String, completion: @escaping ((Int)?) -> ())
    {
        guard
            let r = DB.shared.getRealm,
            let serverUrl = Utils.shared.serverUrl,
            let token = r.objects(SettingsModel.self).first?.AuthToken
        else {
            completion(nil)
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Auth-Token": token
        ]
        
        let place = r.objects(UsersPlaceModel.self).first?.placeUid ?? ""
//
//        let checkinsAreEmpty = DB.shared.getRealm.objects(MBRCheckin.self).filter("isRemoved = false AND tableUid = '\(table.uid)' AND status IN %@", ["new", "approved"]).isEmpty
        
        let parameters: Parameters = [
            "object_uid": table,
            "place_uid": place
        ]
        
        let loginPath = serverUrl + "/objects/code"
        
        DispatchQueue.global(qos: .utility).async {
            AF.request(loginPath, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
    //            .responseJSON { data in
    //                print(data)
    //            }
    //            .validate()
                .responseDecodable(of: ResponseModel<MBRTableCode>.self)
                { (response) in
                    switch response.result {
                    case .success(_):
                        guard let data = response.value else { return }

                        DispatchQueue.main.async {
                            self._saveTableCode(tableUID: table, code: data.payload.code)

                            completion((data.payload.code))
                        }

                        break

                    case .failure(let error):
    //                    Logger.logDebug("*** login \(error)", "")

                        DispatchQueue.main.async {
                            completion(0)
                        }
                        break
                    }
                }
        }
        

    }
}


struct CheckinResponse: Codable
{
    let is_geo_valid: Bool
    
    let uid: String
}
//{"is_geo_valid":true,"uid":"77f1beef-91e4-4fbd-bc52-fa91ed9b9183"}
