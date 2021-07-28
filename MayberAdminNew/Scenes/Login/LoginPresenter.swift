//
//  MainPresenter.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation

final class LoginPresenter
{
    let (email, password) = ("", "")
    
    
    // MARK: - Private properties -

    private unowned let view: LoginViewProtocol
    
    private let interactor: LoginInteractorProtocol
    
    private let wireframe: LoginWireframeProtocol

    // MARK: - Lifecycle -

    init(view: LoginViewProtocol, interactor: LoginInteractorProtocol, wireframe: LoginWireframeProtocol)
    {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -
extension LoginPresenter: LoginPresenterProtocol
{
    func refreshToken(completitionSuccess: @escaping () -> (), completitionWithError: @escaping (String) -> ())
    {
        guard let settings = self.interactor.getUserCredentials() else {
            completitionWithError("NO_USER")
            return
        }
        
        self.interactor.getAuthToken(email: settings.Email, password: settings.Password) { token, email, userUID in
            completitionSuccess()
        } completitionWithError: { error in
            completitionWithError(error)
        }
    }
    
    func IsLogon() -> Bool
    {
        guard let settings = self.interactor.getUserCredentials() else {
            return false
        }
        
        return true
    }
    
    func login(email: String, password: String, completitionSuccess: @escaping () -> (), completitionWithError: @escaping (String) -> ()) {
        self.interactor.login(email: email, password: password) {
            NotificationCenter.default.post(name: Constants.Notify.UserUid, object: nil)
            
            completitionSuccess()
        } completitionWithError: { error in
            completitionWithError(error)
        }
    }
    
    func getSavedLoginPassword() -> [String]
    {
        return [email, password]
    }
    
    func switchToMap()
    {
        self.wireframe.switchToMap()
    }    
}
