//
//  MainPresenter.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

final class MainPresenter {

    // MARK: - Private properties -

    private unowned let view: MainViewProtocol
    
    private let interactor: MainInteractorProtocol
    
    private let wireframe: MainWireframeProtocol

    // MARK: - Lifecycle -

    init(view: MainViewProtocol, interactor: MainInteractorProtocol, wireframe: MainWireframeProtocol)
    {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -
extension MainPresenter: MainPresenterProtocol
{
    func removeAllData()
    {
        self.interactor.removeAllData()
    }
    
    func removeObservers()
    {
        self.interactor.removeObservers()
    }
    
    func syncTables(finish: @escaping (String) -> (), updateTables: @escaping () -> ())
    {
        self.interactor.syncTables { place_uid in
            finish(place_uid)
        } updateTables: {
            updateTables()
        }
    }
    
    func syncUserData()
    {
        self.interactor.syncUserData()
    }
    
    func syncOrderItems(placeUid: String, finish: @escaping (String, String) -> ())
    {
        self.interactor.syncOrderItems(placeUid: placeUid) { (uid, checkin_uid) in
            finish(uid, checkin_uid)
        }
    }
    
    func syncCheckins(placeUid: String, finish: @escaping (_ tableUID: String, _ checkinUID: String) -> (), finishAll: @escaping () -> ())
    {
        self.interactor.syncCheckins(placeUid: placeUid) { tableUID, checkinUID in
            finish(tableUID, checkinUID )
        } finishAll: {
            finishAll()
        }
    }

    func syncMenuAll(finish: @escaping () -> ()) {
        self.interactor.syncMenuAll {
            finish()
        }
    }
    
    func syncPlaces(finish: @escaping () -> ())
    {
        self.interactor.syncPlaces
        {
            finish()
        }
    }
    
    func switchToStartController()
    {
//        Logger.log("\(type(of: self))")
        
        self.wireframe.switchToStartController()
    }
}
