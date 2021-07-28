//
//  MapInteractor.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import Alamofire

final class MapInteractor {
    
    // MARK:- Private data -
    private var tables: [TableModel]!
    private var placeUid: String!
    
    private var _currency = ""
}

// MARK:- Extensions -

extension MapInteractor: MapInteractorProtocol
{
//    func getCheckin(tableUid: String, checkinUid: String) -> CheckinModel {
//        <#code#>
//    }
    
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
    
    func getTable(uid: String) -> TableModel?
    {
        if let r = DB.shared.getRealm, let table = r.objects(TableModel.self).filter("uid = '\(uid)'").first
        {
            return table
        }
        
        return nil
    }
    
    func saveTablePosition(uid: String, x: Float, y: Float, rotation: Float)
    {
        guard  let r = DB.shared.getRealm else { return }
        
        guard let table = r.objects(TableModel.self).filter("uid = '\(uid)'").first else { return }
        
        try! r.write {
            table.parameters.x = x
            table.parameters.y = y
            table.parameters.rotation = rotation
        }
    }
    
    func setTablesAsRemoved(uids: [String])
    {
        guard  let r = DB.shared.getRealm else { return }
//
        for uid in uids
        {
            if let table = r.objects(TableModel.self).filter("uid = '\(uid)'").first
            {
                try! r.write {
                    table.isRemoved = true
                }
            }
        }
    }
    
    func deleteTables(uids: [String], completitionSuccess: @escaping () -> (), completitionWithError: @escaping (String) -> ())
    {
        
        guard let serverUrl = Utils.shared.serverUrl else {
            return
        }
        
        guard let r = DB.shared.getRealm, let token = r.objects(SettingsModel.self).first?.AuthToken else {
            return
        }
        
        let place = r.objects(UsersPlaceModel.self).first
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Auth-Token": token
        ]
        
        let path = serverUrl + "/objects/delete"
        
        var _data = [String: Any]()
        
        _data = [
            "objects_uids": uids,
            "place_uid": place!.placeUid
        ]
        
        AF.request(path, method: .post, parameters: _data, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print("*** deleteTable 3")
                print(response)

                completitionSuccess()
            }
    }
    
    func saveTables(data: [Any],
                    completitionSuccess: @escaping () -> (),
                    completitionWithError: @escaping (_ error: String) -> ())
    {
        /*{
         "objects": [
           {
             "number": "string",
             "params": {
               "height": "string",
               "rotation": 0,
               "seats": "string",
               "width": "string",
               "x": "string",
               "y": "string"
             },
             "party_name": "string",
             "place_uid": "string",
             "type": "string",
             "uid": "string"
           }
         ],
         "place_uid": "string"
       }*/
        
        
        guard let serverUrl = Utils.shared.serverUrl else {
            return
        }
        
        guard let r = DB.shared.getRealm, let token = r.objects(SettingsModel.self).first?.AuthToken else {
            return
        }
        
        let place = r.objects(UsersPlaceModel.self).first
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Auth-Token": token
        ]
        
        let path = serverUrl + "/objects"
        
        var _data = [String: Any]()
        
        _data = [
            "objects": data,
            "place_uid": place!.placeUid
        ]
        
        print("*** saveTables 2")
        print(_data)
        
        AF.request(path, method: .post, parameters: _data, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print("*** saveTables 3")
                print(response)

                completitionSuccess()
            }
//            .validate()
//            .responseDecodable(of: MBRResponse<OrderPayPayloadResponse>.self)
//            { (response) in
//                switch response.result {
//                case .success(_):
//                    guard let data = response.value else { return }
//
//                    if(data.status == "SUCCESS")
//                    {
//                        completitionSuccess(data.payload.InvoiceUID!)
//                    }
//                    else
//                    {
//                        Logger.log("*** login \(data.errorCode)")
//
//                        completitionWithError("*** login \(data.errorCode)")
//                    }
//
//                    break
//
//                case .failure(let error):
//                    Logger.log("*** login \(error)")
//
//                    completitionWithError("*** login \(error)")
//                    break
//                }
//            }
    }
    
    func getOrdersCount() -> Int
    {
        guard let r = DB.shared.getRealm else {
            return 0
        }
        
        let checkins = r.objects(CheckinModel.self).filter("isRemoved = false AND status IN %@", ["new", "approved"]).sorted(byKeyPath: "number", ascending: true)
        
        return checkins.count
    }
    
    func getOorderAmount() -> Double
    {
        guard let r = DB.shared.getRealm else {
            return 0
        }
        
        let checkins = r.objects(CheckinModel.self).filter("isRemoved = false AND status IN %@", ["new", "approved"]).sorted(byKeyPath: "number", ascending: true)
        
        return  checkins.reduce(0) { $0 + $1.total }                
    }
    
    func storeCode(_ code: Int, tableUid: String)
    {
        guard let r = DB.shared.getRealm else {
            return
        }
        
        try! r.write {
            tables.first { $0.uid == tableUid }?.code = code
        }
    }
    
    func getPlace() -> String
    {
        guard let r = DB.shared.getRealm, placeUid == nil else {
            return placeUid
        }
        
        guard let placeUidResult = r.objects(UsersPlaceModel.self).first?.placeUid else {
            return ""
        }
        
        placeUid = placeUidResult
        
        return placeUid
    }
    
    func getTables(placeUid: String, forced: Bool = false) -> [TableModel]
    {
        if(!forced)
        {
            guard tables == nil else {
                return tables
            }
        }
        
        guard let r = DB.shared.getRealm else {
            return [TableModel]()
        }

        
        let tablesResult = r.objects(TableModel.self).filter("isRemoved = false")
        
        tables = tablesResult.map { $0 }
        
        return tables
    }
    
    func getTables() -> [TableModel]
    {
        guard let r = DB.shared.getRealm else {
            return [TableModel]()
        }
        
        let tables = r.objects(TableModel.self)
        
        return Array(tables)
    }

    func getCheckins() -> [CheckinModel]
    {
        guard let r = DB.shared.getRealm else {
            return [CheckinModel]()
        }
        
        let checkins = r.objects(CheckinModel.self).filter("isRemoved = false AND status IN %@", ["new", "approved"]).sorted(byKeyPath: "number", ascending: true)
        
        return Array(checkins)
    }    
    
    func getCheckin(tableUid: String, checkinUid: String) -> CheckinModel?
    {
        guard let r = DB.shared.getRealm else {
            return nil
        }
        
        let checkinResult = r.objects(CheckinModel.self)
            .filter("tableUid == '\(tableUid)' AND checkinUid == '\(checkinUid)'")
        
        return checkinResult.first
    }
    
    func getCode(table: TableModel) -> Bool
    {
//        guard
//            let serverUrl = Utils.shared.serverUrl,
//            let token = DB.shared.getRealm.objects(SettingsModel.self).first?.AuthToken
//        else {
//            completion(nil)
//            return
//        }
//
//        let headers: HTTPHeaders = [
//            "Content-Type": "application/json",
//            "X-Auth-Token": token
//        ]
//
//        let place = DB.shared.getRealm.objects(UsersPlaceModel.self).first?.placeUid ?? ""
//
        guard let r = DB.shared.getRealm else {
            return false
        }
        
        return r.objects(CheckinModel.self).filter("isRemoved = false AND tableUid = '\(table.uid)' AND status IN %@", ["new", "approved"]).count > 0
//
//        let parameters: Parameters = [
//            "object_uid": table.uid,
//            "place_uid": place
//        ]
//
//        let loginPath = serverUrl + "/objects/code"
//
//        AF.request(loginPath, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//            .validate()
//            .responseDecodable(of: ResponseModel<MBRTableCode>.self)
//            { (response) in
//                switch response.result {
//                case .success(_):
//                    guard let data = response.value else { return }
//                    completion((data.payload.code, checkinsAreEmpty))
//
//                    break
//
//                case .failure(let error):
////                    Logger.logDebug("*** login \(error)", "")
//
//                    completion(nil)
//                    break
//                }
//            }
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

        let parameters: Parameters = [
            "object_uid": table,
            "place_uid": place
        ]
        
        let loginPath = serverUrl + "/objects/code"
        
        DispatchQueue.global(qos: .utility).async {
            AF.request(loginPath, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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
    
    private func _saveTableCode(tableUID: String, code: Int)
    {
        guard let r = DB.shared.getRealm, let table = r.objects(TableModel.self).filter("uid = '\(tableUID)'").first else {
            return
        }
        
        try! r.write {
            table.code = code
        }
    }
}

struct MBRTableCode: Codable {
    let code: Int
    let life_time_nano_sec: Int
}
