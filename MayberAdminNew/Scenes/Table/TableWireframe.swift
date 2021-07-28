//
//  MainWireframe.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

final class TableWireframe: BaseWireframe {

    // MARK: - Private properties -
    
    private var _tableUID = ""
    
    private var _prev = ""

    // MARK: - Module setup -

    init(params: [String : Any])
//    init(tableUID: String, prev: String)
    {
//        Logger.log("\(type(of: self))")
        
        _tableUID = params["tableUID"] as? String ?? ""
        
        _prev = params["prev"] as? String ?? ""
        
//        print("*** TableWireframe UID \(_tableUID)")
        
        let moduleViewController = TableViewController()
        super.init(viewController: moduleViewController, name: "table")

        let interactor = TableInteractor(tableUID: _tableUID)
        let presenter = TablePresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

    override func ReloadParams(params: [String : Any])
    {
        _tableUID = params["tableUID"] as? String ?? ""
        
        _prev = params["prev"] as? String ?? ""
    }
}

// MARK: - Extensions -

extension TableWireframe: TableWireframeProtocol
{
    func GoToMenuItemDetails(uid: String)
    {
        ChangeController(name: "details", params: ["menuItemUID" : uid], transition: .Right)
    }
    
    func GoBack()
    {
        if(_prev == "orders")
        {
            ChangeController(name: "orders", transition: .Right)
        }
        else if(_prev == "map")
        {
            ChangeController(name: "map", transition: .Right)
        }
        else
        {
            ChangeController(name: "seats", params: ["tableUid": _tableUID, "sender": "table"], transition: .Left)
        }
        
        RemoveController(name: "table")
    }
        
    func GoToMap()
    {
        print("*** TableWireframe GoToMap")
        
        ChangeController(name: "map", transition: .None)
    }
}
