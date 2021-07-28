//
//  MapWireframe.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

final class MapWireframe: BaseWireframe {

    // MARK: - Private properties -

    // MARK: - Module setup -
    
    init()
    {
        print("*** MapWireframe INIT")
        
        
        let mapViewController = MapViewController()
        super.init(viewController: mapViewController, name: "map")

        let interactor = MapInteractor()
        let presenter = MapPresenter(view: mapViewController, interactor: interactor, wireframe: self)
        mapViewController.presenter = presenter
        
    }
    
    override func ReloadParams(params: [String : Any])
    {
        
    }
}

// MARK: - Extensions -
extension MapWireframe: MapWireframeProtocol
{
    
    func switchToUserProfileController()
    {
        ChangeController(name: "profile", transition: .Left)
        
//        RemoveController(name: "map")
    }
    
    func switchToOrdersController()
    {
        ChangeController(name: "orders", transition: .Right)
        
//        RemoveController(name: "map")
    }
    
    func openTable(tableUid: String)
    {
//        ChangeController(name: "map", transition: .Right)
        ChangeController(name: "table", params: ["tableUid": tableUid, "sender": "map"], transition: .Right)
    }
    
    func openSeats(tableUid: String)
    {
        ChangeController(name: "seats", params: ["tableUid": tableUid, "sender": "map"], transition: .Right)
    }
}
