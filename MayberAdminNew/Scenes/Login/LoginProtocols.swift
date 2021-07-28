//
//  MainProtocols.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

protocol LoginWireframeProtocol: WireframeProtocol
{
    func switchToMap()
}

protocol LoginViewProtocol: ViewProtocol {

}

protocol LoginPresenterProtocol: PresenterProtocol
{
    func switchToMap()
    
    func refreshToken(completitionSuccess: @escaping () -> (), completitionWithError: @escaping ( _ error: String) ->  ())
    
    func IsLogon() ->  Bool
    
    func getSavedLoginPassword() -> [String]
    
    func login(email: String, password: String, completitionSuccess: @escaping () -> (), completitionWithError: @escaping ( _ error: String) ->  ())
}

protocol LoginInteractorProtocol: InteractorProtocol
{
    func getUserCredentials() -> SettingsModel?
    
    func getAuthToken(email: String, password: String, completitionSuccess: @escaping (_ token: String, _ email: String, _ userUID: String) -> (), completitionWithError: @escaping ( _ error: String) ->  ())
    
    func login(email: String, password: String, completitionSuccess: @escaping () -> (), completitionWithError: @escaping ( _ error: String) ->  ())
}
