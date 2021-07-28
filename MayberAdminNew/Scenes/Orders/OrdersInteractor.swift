//
//  MainInteractor.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import Alamofire
//import RealmSwift

final class OrdersInteractor
{
    private var _currency = ""
}

// MARK: - Extensions -

extension OrdersInteractor: OrdersInteractorProtocol
{
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
    
    func getUserUID() -> String
    {
        if let r = DB.shared.getRealm, let user = r.objects(UserModel.self).first
        {
            return user.userUid
        }
        
        return ""
    }
    
    func getCheckins() -> [CheckinModel]
    {
        guard let r = DB.shared.getRealm else {
            return [CheckinModel]()
        }
        
        let checkins = r.objects(CheckinModel.self).filter("isRemoved = false AND status IN %@", ["new", "approved"]).sorted(byKeyPath: "guestNumber", ascending: true)
        
        return Array(checkins)
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
    
    func CloseCheckinsAsPaidByTableUID(tableUID: String, finishWithSuccess: @escaping () -> (), finishWithError: @escaping () -> ())
    {

    }
    
    func InvoicesCancel(payload: [String: Any], finish: @escaping () -> ())
    {
        guard let serverUrl = Utils.shared.serverUrl else {
            return
        }
        
        guard let r = DB.shared.getRealm, let token = r.objects(SettingsModel.self).first?.AuthToken else {
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Auth-Token": token
        ]
        
        print("*** InvoicesCancel 1.1")
        print(payload)
        
        var path = serverUrl + "/checkins/status/cancel"
        
        AF.request(path, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: headers)
//            .validate()
            .responseJSON { data in
                
                print("*** InvoicesCancel 1.2")
                print(data.result)
                
                finish()
            }
    }
    
    func SetInvoiceStatus(payload: [String: Any], finish: @escaping () -> ())
    {
        guard let serverUrl = Utils.shared.serverUrl else {
            return
        }
        
        guard let r = DB.shared.getRealm, let token = r.objects(SettingsModel.self).first?.AuthToken else {
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Auth-Token": token
        ]
        
        var path = serverUrl + "/orders/setInvoicePaymentState"
        
        AF.request(path, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { data in
                
                print("*** SetInvoiceStatus 1")
                print(data.result)
                
                finish()
            }
        
        
    }
    
    func PayCheckins(data: [String: Any],
                     completitionSuccess: @escaping (_ checkinUID: String) -> (),
                     completitionWithError: @escaping (_ error: String) -> ())
    {
        
        print("*** PayCheckins 1")
        
        guard let serverUrl = Utils.shared.serverUrl else {
            return
        }
        
        guard let r = DB.shared.getRealm, let token = r.objects(SettingsModel.self).first?.AuthToken else {
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Auth-Token": token
        ]

        let path = serverUrl + "/orders/pay"
        
        print(data)
        
        AF.request(path, method: .post, parameters: data, encoding: JSONEncoding.default, headers: headers)
//            .validate()
//            .responseJSON { data in
//
//                print("*** PayCheckins 1.1")
//                print(data.result)
//
////                finish()
//            }
//            .validate()
            .responseDecodable(of: ResponseModel<OrderPayPayloadResponse>.self)
            { (response) in
                switch response.result {
                case .success(_):
                    guard let data = response.value else { return }

                    if(data.status == "SUCCESS")
                    {
                        print("*** PayCheckins 2")
                        completitionSuccess(data.payload.InvoiceUID!)
                    }
                    else
                    {
                        print("*** PayCheckins 3")
//                        Logger.log("*** login \(data.errorCode)")

                        completitionWithError("*** login \(data.errorCode)")
                    }

                    break

                case .failure(let error):
                    print("*** PayCheckins 4")
//                    Logger.log("*** login \(error)")

                    completitionWithError("*** login \(error)")
                    break
                }
            }
    }
}
