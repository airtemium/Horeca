//
//  MainWireframe.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

final class SeatsWireframe: BaseWireframe {

    // MARK: - Private properties -

    // MARK: - Module setup -
    
    private var _tableUid = ""
    
    private var _sender = ""

//    init(tableUid: String, sender: String)
    init(params: [String: Any])
    {
//        Logger.log("\(type(of: self))")
        
        _tableUid = params["tableUid"] as? String ?? ""
        
        _sender = params["sender"] as? String ?? ""
        
        let moduleViewController = SeatsViewController()
        super.init(viewController: moduleViewController, name: "seats")

        let interactor = SeatsInteractor(tableUid: _tableUid)
        let presenter = SeatsPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

    override func ReloadParams(params: [String : Any])
    {
        _tableUid = params["tableUid"] as? String ?? ""
        
        _sender = params["sender"] as? String ?? ""
    }
}

// MARK: - Extensions -

extension SeatsWireframe: SeatsWireframeProtocol
{
    func GoToMenuItemDetails(uid: String)
    {
        ChangeController(name: "details", params: ["menuItemUID" : uid], transition: .Right)
    }
    
    func switchToTable()
    {
        ChangeController(name: "table", params: ["tableUID": _tableUid, "prev": "seats"], transition: .Right)
        
        RemoveController(name: "seats")
    }
    
    func BackToMap()
    {
        if(_sender == "orders")
        {
            ChangeController(name: "orders", transition: .Left)
            
            RemoveController(name: "seats")
        }
        else
        {
            ChangeController(name: "map", transition: .Left)
            
            RemoveController(name: "seats")
        }
    }    
}
