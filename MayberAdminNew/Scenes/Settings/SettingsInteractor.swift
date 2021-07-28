//
//  MainInteractor.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation

final class SettingsInteractor {
    
}

// MARK: - Extensions -

extension SettingsInteractor: SettingsInteractorProtocol
{
    func getCurrentUser() -> UserModel?
    {
        guard let r = DB.shared.getRealm, let user = r.objects(UserModel.self).first else {
            return nil
        }
        
        return user
    }
    
    func getCurrentPlace() -> UsersPlaceModel?
    {
        guard let r = DB.shared.getRealm, let place = r.objects(UsersPlaceModel.self).first else {
            return nil
        }
        
        return place
    }
    

}
