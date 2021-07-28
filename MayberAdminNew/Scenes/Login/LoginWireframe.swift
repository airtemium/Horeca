//
//  MainWireframe.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

final class LoginWireframe: BaseWireframe {

    // MARK: - Private properties -

    // MARK: - Module setup -

    init()
    {
//        Logger.log("\(type(of: self))")
        
        let moduleViewController = LoginViewController()
        super.init(viewController: moduleViewController, name: "login")

        let interactor = LoginInteractor()
        let presenter = LoginPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension LoginWireframe: LoginWireframeProtocol
{
    func switchToMap()
    {
        ChangeController(name: "map", transition: .Right)
//        ChangeController(name: "orders", transition: .Right)
        
//        ChangeController(name: "seats", params: ["tableUid" : "01d378e8-ec84-4a6c-8666-9ea5e9012ba1"], transition: .None)
        
        RemoveController(name: "login")
    }
}
