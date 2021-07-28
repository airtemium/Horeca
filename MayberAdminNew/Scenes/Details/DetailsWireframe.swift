//
//  MainWireframe.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

final class DetailsWireframe: BaseWireframe {

    // MARK: - Private properties -

    // MARK: - Module setup -
    
    private var _menuItemUID = ""

//    init(menuItemUID: String)
    init(params: [String: Any])
    {
//        Logger.log("\(type(of: self))")
        
        _menuItemUID = params["menuItemUID"] as? String ?? ""
        
        let moduleViewController = DetailsViewController()
        super.init(viewController: moduleViewController, name: "details")

        let interactor = DetailsInteractor(menuItemUID: _menuItemUID)
        let presenter = DetailsPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension DetailsWireframe: DetailsWireframeProtocol
{
    func GoBack()
    {
        print("*** DetailsWireframe GoBack")
        
        RemoveController(name: "details", transition: .Right)
    }    
}
