//
//  MainPresenter.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation

final class ProfilePresenter
{
    // MARK: - Private properties -

    private unowned let view: ProfileViewProtocol
    
    private let interactor: ProfileInteractorProtocol
    
    private let wireframe: ProfileWireframeProtocol

    // MARK: - Lifecycle -

    init(view: ProfileViewProtocol, interactor: ProfileInteractorProtocol, wireframe: ProfileWireframeProtocol)
    {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -
extension ProfilePresenter: ProfilePresenterProtocol
{
    func GoToOrders()
    {
        self.wireframe.GoToOrders()
    }
    
    func Logout()
    {
        self.wireframe.Logout()
    }
    
    func GoBack()
    {
        self.wireframe.GoBack()
    }
    
    func getFullName() -> String
    {
        guard let user = self.interactor.getCurrentUser() else {
            return ""
        }
        
        return user.FullName
    }
}
