//
//  MainProtocols.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

protocol SettingsWireframeProtocol: WireframeProtocol
{
    func switchToMap()
    
    func switchToOrders()
    
    func GoToProfile()
}

protocol SettingsViewProtocol: ViewProtocol
{

}

protocol SettingsPresenterProtocol: PresenterProtocol
{
    func switchToMap()
    
    func switchToOrders()
    
    func getFullName() -> String
    
    func getDescription() -> String
    
    func GoToProfile()
}

protocol SettingsInteractorProtocol: InteractorProtocol
{
    func getCurrentUser() -> UserModel?
    
    func getCurrentPlace() -> UsersPlaceModel?
}
