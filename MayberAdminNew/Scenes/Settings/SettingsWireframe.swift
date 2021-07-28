//
//  MainWireframe.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

final class SettingsWireframe: BaseWireframe {

    // MARK: - Private properties -

    // MARK: - Module setup -

    init()
    {
//        Logger.log("\(type(of: self))")
        
        let moduleViewController = SettingsViewController()
        super.init(viewController: moduleViewController, name: "settings")

        let interactor = SettingsInteractor()
        let presenter = SettingsPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension SettingsWireframe: SettingsWireframeProtocol
{
    func GoToProfile()
    {
//        navigationController?.pushWireframe(ProfileWireframe())
    }
    
    func switchToMap()
    {
//        navigationController?.pushWireframe(MapWireframe())
    }
    
    func switchToOrders()
    {
//        navigationController?.pushWireframe(OrdersWireframe())
    }
}
