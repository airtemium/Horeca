//
//  MainWireframe.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

final class ProfileWireframe: BaseWireframe {

    // MARK: - Private properties -

    // MARK: - Module setup -

    init()
    {
//        Logger.log("\(type(of: self))")
        
        let moduleViewController = ProfileViewController()
        
        super.init(viewController: moduleViewController, name: "profile")

        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension ProfileWireframe: ProfileWireframeProtocol
{
    func GoToOrders()
    {
        ChangeController(name: "orders", transition: .Left)
    }
    
    func GoBack()
    {
        ChangeController(name: "map", transition: .Right)
    }
    
    func Logout()
    {
        RemoveController(name: "profile")
    }
}
