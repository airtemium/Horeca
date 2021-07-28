//
//  MainWireframe.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

final class LoaderWireframe: BaseWireframe {

    // MARK: - Private properties -

    // MARK: - Module setup -

    init()
    {
//        Logger.log("\(type(of: self))")
        
        let moduleViewController = LoaderViewController()
        super.init(viewController: moduleViewController, name: "loader")

        let interactor = LoaderInteractor()
        let presenter = LoaderPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension LoaderWireframe: LoaderWireframeProtocol
{
    func switchToMain()
    {
        ChangeController(name: "login", transition: .None)
        
        RemoveController(name: "loader")
    }
}
