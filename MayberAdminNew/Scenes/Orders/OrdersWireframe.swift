//
//  MainWireframe.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

final class OrdersWireframe: BaseWireframe {

    // MARK: - Private properties -

    // MARK: - Module setup -

    init()
    {
        print("*** OrdersWireframe init")
        
        let moduleViewController = OrdersViewController()
        super.init(viewController: moduleViewController, name: "orders")

        let interactor = OrdersInteractor()
        let presenter = OrdersPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension OrdersWireframe: OrdersWireframeProtocol
{
    func SwitchToProfile()
    {
        ChangeController(name: "profile", transition: .Right)
    }
    
    func OpenTable(tableUID: String, prev: String)
    {
        ChangeController(name: "seats", params: ["tableUid": tableUID], transition: .Right)
    }
    
    func SwitchTomap()
    {
        ChangeController(name: "map", transition: .Left)
    }
    
}
