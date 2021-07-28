//
//  MainPresenter.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation

final class SettingsPresenter
{
    // MARK: - Private properties -

    private unowned let view: SettingsViewProtocol
    
    private let interactor: SettingsInteractorProtocol
    
    private let wireframe: SettingsWireframeProtocol

    // MARK: - Lifecycle -

    init(view: SettingsViewProtocol, interactor: SettingsInteractorProtocol, wireframe: SettingsWireframeProtocol)
    {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -
extension SettingsPresenter: SettingsPresenterProtocol
{
    func GoToProfile()
    {
        self.wireframe.GoToProfile()
    }
    
    func getFullName() -> String
    {
        guard let user = self.interactor.getCurrentUser() else {
            return ""
        }
        
        return user.FullName
    }
    
    func getDescription() -> String
    {
        guard let place = self.interactor.getCurrentPlace() else {
            return ""
        }
        
        guard let user = self.interactor.getCurrentUser() else {
            return ""
        }
        
        return "\(user.RoleName), \(place.Name)"
    }
    
    func switchToMap()
    {
        self.wireframe.switchToMap()
    }
    
    func switchToOrders()
    {
        self.wireframe.switchToOrders()
    }       
}
