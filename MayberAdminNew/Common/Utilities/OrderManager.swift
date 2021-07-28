//
//  OrderManager.swift
//  MayberAdminNew
//
//  Created by Artem on 03.06.2021.
//

import Foundation
import Alamofire

class OrderManager
{
    private var _headers: HTTPHeaders?
    
    var _serverUrl = ""
    
    var _checkinUID = ""
    
    var _tableUID = ""
    
    var _placeUID = ""
    
    var _userUID = ""
            
    init(checkinUID: String, tableUID: String, placeUID: String, userUID: String = "")
    {
        _checkinUID = checkinUID
        
        _tableUID = tableUID
        
        _placeUID = placeUID
        
        _userUID = userUID
        
        _init()
    }

    
    private func _init()
    {
        guard let serverUrl = Utils.shared.serverUrl else {
            return
        }
        
        _serverUrl = serverUrl
        
        guard let r = DB.shared.getRealm, let token = r.objects(SettingsModel.self).first?.AuthToken else {
            return
        }
        
        _headers = [
            "Content-Type": "application/json",
            "X-Auth-Token": token
        ]
    
    }
    
    init()
    {
        _init()
    }
    
    func Move(toCheckinUID: String, data: [String], completitionWithError: @escaping (_ error: String) -> (), completitionSuccess: @escaping () -> ())
    {
        let path = _serverUrl + "/orders/move"
        
        /*
         
     move order

     Example Value
     Model
     {
       "from_checkin_uid": "string",
       "item_uids": [
         "string"
       ],
       "object_uid": "string",
       "place_uid": "string",
       "to_checkin_uid": "string",
       "user_uid": "string"
     }
         */
        
        let payload: [String: Any] = [
            "from_checkin_uid": _checkinUID,
            "to_checkin_uid": toCheckinUID,
            "item_uids": data,
            "object_uid": _tableUID,
            "place_uid": _placeUID,
//            "user_uid": _userUID
          ]
        
        print("*** OrderManager Move")
        print(payload)
        
        AF.request(path, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: _headers)
        .responseJSON { response in

            print(response)
            completitionSuccess()
        }
    }
    
    func Confirm(data: [String], completitionWithError: @escaping (_ error: String) -> (), completitionSuccess: @escaping () -> ())
    {
        print("** CONFIRM ITEMS")
        
        let path = _serverUrl + "/orders/status/approve"
        
//        let path = _serverUrl + "/orders/confirm"
        
        var payload: [String: Any] = [
            "item_uids": data,
            "object_uid": _tableUID,
            "place_uid": _placeUID,
            "user_uid": _userUID
          ]

//        var payload: [String: Any] = [
//            "item_uids": data
//          ]
        
        print(payload)
        
        AF.request(path, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: _headers)
            .responseJSON { response in

                print(response)
                completitionSuccess()
            }
//            .validate()
//            .responseDecodable(of: MBRResponse<[OrderNewPayloadResponse]>.self)
//            { (response) in
//                switch response.result {
//                case .success(_):
//                    guard let data = response.value else { return }
////
//                    if(data.status == "SUCCESS")
//                    {
//                        completitionSuccess()
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
////                    Logger.log("*** login \(error)")
////
////                    completitionWithError("*** login \(error)")
//                    break
//                }
//            }
    }
    
    func Fire(data: [String], completitionWithError: @escaping (_ error: String) -> (), completitionSuccess: @escaping () -> ())
    {
        let path = _serverUrl + "/orders/fire"
        
        let payload: [String: Any] = [
//            "checkin_uid": _checkinUID,
            "item_uids": data,
            "object_uid": _tableUID,
            "place_uid": _placeUID,
//            "user_uid": _userUID
          ]
        
        print("*** OrderManager Fire")
        print(payload)
        
        AF.request(path, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: _headers)
        .responseJSON { response in

            print(response)
            completitionSuccess()
        }
    }
    
    func New(data: [[String: Any]], completitionWithError: @escaping (_ error: String) -> (), completitionSuccess: @escaping () -> ())
    {
        let path = _serverUrl + "/orders/new"
        
        let payload: [String: Any] = [
            "checkin_uid": _checkinUID,
            "items": data,
            "object_uid": _tableUID,
            "place_uid": _placeUID,
//            "user_uid": _userUID
          ]
        
        print("*** OrderManager New")
        print(payload)
        
        AF.request(path, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: _headers)
            .responseJSON { response in

                print(response)
                completitionSuccess()
            }
//            .validate()
//            .responseDecodable(of: MBRResponse<[OrderNewPayloadResponse]>.self)
//            { (response) in
//                switch response.result {
//                case .success(_):
//                    guard let data = response.value else { return }
////
//                    if(data.status == "SUCCESS")
//                    {
//                        completitionSuccess()
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
////                    Logger.log("*** login \(error)")
////
////                    completitionWithError("*** login \(error)")
//                    break
//                }
//            }
    }
    
    func Change(data: [String: Any], completitionWithError: @escaping (_ error: String) -> (), completitionSuccess: @escaping () -> ())
    {
        let path = _serverUrl + "/orders/change"
        
        var payload: [String: Any] = [
            "checkin_uid": _checkinUID,
            "items": data,
            "object_uid": _tableUID,
            "place_uid": _placeUID,
            "user_uid": _userUID
          ]
        
        AF.request(path, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: _headers)
            .validate()
            .responseDecodable(of: ResponseModel<[OrderNewPayloadResponse]>.self)
            { (response) in
                switch response.result {
                case .success(_):
                    guard let data = response.value else { return }
//
                    if(data.status == "SUCCESS")
                    {
                        completitionSuccess()
                    }
                    else
                    {
                        Logger.log("*** login \(data.errorCode)")

                        completitionWithError("*** login \(data.errorCode)")
                    }
                                                                                             
                    break

                case .failure(let error):
//                    Logger.log("*** login \(error)")
//
//                    completitionWithError("*** login \(error)")
                    break
                }
            }
    }
    
    func Deny(data: [String], completitionWithError: @escaping (_ error: String) -> (), completitionSuccess: @escaping () -> ())
    {
        print("**** OREdErs MANAGER DENY")
        
        let path = _serverUrl + "/orders/deny"
        
        let payload: [String: Any] = [
//            "checkin_uid": _checkinUID,
            "items_uids": data,
            "object_uid": _tableUID,
            "place_uid": _placeUID,
//            "user_uid": _userUID
          ]
        
        
        
        print("*** OrderManager Deny")
        print(payload)
        
        AF.request(path, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: _headers)
        .responseJSON { response in

            print(response)
            completitionSuccess()
        }
    }
    
    func Fire()
    {
        
    }
    
    func Confirm()
    {
        
    }
}
