//
//  MainInteractor.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import Firebase
import Alamofire
import RealmSwift

final class LoginInteractor {
    
}

// MARK: - Extensions -

extension LoginInteractor: LoginInteractorProtocol
{
    func getUserCredentials() -> SettingsModel?
    {
        if let r = DB.shared.getRealm, let settings = r.objects(SettingsModel.self).first
        {
            return settings
        }
        
        return nil
    }
    
    func getAuthToken(email: String, password: String, completitionSuccess: @escaping (_ token: String, _ email: String, _ userUID: String) -> (), completitionWithError: @escaping ( _ error: String) ->  ())
    {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authDataResult, error in
            //
//            Logger.log("\(type(of: self))")

            guard let user = authDataResult?.user else {
//                Logger.log("!!! No user")
                
                completitionWithError("!!! No user")
                return
            }
            
            user.getIDToken() { (token, error) in
                guard let token = token else {
//                    Logger.log("!!! No token")
                    
                    completitionWithError("No token")
                    return
                }

                guard let serverUrl = Utils.shared.serverUrl else {
                    return
                }
                
                let settings = SettingsModel()
                settings.AuthToken = token
                settings.Email = email
                settings.Password = password
                settings.UserUID = user.uid
                
                guard let r = DB.shared.getRealm else {
                    completitionWithError("ERROR_INIT_DB")
                    return
                }
                
                try! r.write {
                    r.add(settings, update: .all)
                }
                
                completitionSuccess(token, email, user.uid)
                
            }
        }
    }
    
    func login(email: String, password: String, completitionSuccess: @escaping () -> (), completitionWithError: @escaping ( _ error: String) ->  ())
    {
        self.getAuthToken(email: email, password: password) { token, email, userUID in
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "X-Auth-Token": token
            ]
            
            let parameters: Parameters = [
                "user": [
                    "email" : email,
                    "fcm_tokens": [token],
                    "uid": userUID
                ]
            ]
            
            guard let serverUrl = Utils.shared.serverUrl else {
                return
            }
                            
            let loginPath = serverUrl + "/users/login"
            
            AF.request(loginPath, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseDecodable(of: ResponseModel<UserModel>.self)
                { (response) in
                    switch response.result {
                    case .success(_):
                        guard let data = response.value else { return }
                        
                        guard let r = DB.shared.getRealm else {
                            completitionWithError("ERROR_INIT_DB")
                            return
                        }
                        
                        try! r.write {
                            r.add(data.payload, update: .all)
                        }
                                                                                
                        completitionSuccess()
                        
                        break

                    case .failure(let error):
//                        Logger.log("*** login \(error)")
                        
                        completitionWithError("*** login \(error)")
                        break
                    }
                }
        } completitionWithError: { error in
            completitionWithError(error)
        }
    }
}
