//
//  MainProtocols.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

protocol MainWireframeProtocol: WireframeProtocol
{
    func switchToStartController()
}

protocol MainViewProtocol: ViewProtocol {

}

protocol MainPresenterProtocol: PresenterProtocol
{    
    func switchToStartController()
    
    func syncPlaces(finish: @escaping () -> ())
    
    func syncMenuAll(finish: @escaping () -> ())
    
    func syncTables(finish: @escaping (_ placeUID: String) -> (), updateTables: @escaping () -> ())
    
    func syncOrderItems(placeUid: String, finish: @escaping (_ uid: String, _ checkin_uid: String) -> ())
    
    func syncCheckins(placeUid: String, finish: @escaping (_ tableUID: String, _ checkinUID: String) -> (), finishAll: @escaping () -> ())
    
    func syncUserData()
    
    func removeObservers()
    
    func removeAllData()
}

protocol MainInteractorProtocol: InteractorProtocol
{
    func removeAllData()
    
    func removeObservers()
    
    func syncUserData()
    
    func syncPlaces(finish: @escaping () -> ())
    
    func syncMenuAll(finish: @escaping () -> ())
    
    func syncTables(finish: @escaping (_ placeUID: String) -> (), updateTables: @escaping () -> ())
    
    func syncOrderItems(placeUid: String, finish: @escaping (_ uid: String, _ checkin_uid: String) -> ())
    
    func syncCheckins(placeUid: String, finish: @escaping (_ tableUID: String, _ checkinUID: String) -> (), finishAll: @escaping () -> ())
}
