//
//  MainProtocols.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

protocol ProfileWireframeProtocol: WireframeProtocol
{
    func GoBack()
    
    func Logout()
    
    func GoToOrders()
}

protocol ProfileViewProtocol: ViewProtocol
{

}

protocol ProfilePresenterProtocol: PresenterProtocol
{
    func GoBack()
    
    func getFullName() -> String
    
    func Logout()
    
    func GoToOrders()
}

protocol ProfileInteractorProtocol: InteractorProtocol
{
    func getCurrentUser() -> UserModel?
}
