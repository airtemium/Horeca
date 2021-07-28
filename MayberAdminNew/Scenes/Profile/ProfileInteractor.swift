//
//  MainInteractor.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation


final class ProfileInteractor {
    
}

// MARK: - Extensions -

extension ProfileInteractor: ProfileInteractorProtocol
{
    func getCurrentUser() -> UserModel?
    {
        guard let r = DB.shared.getRealm, let user = r.objects(UserModel.self).first else {
            return nil
        }
        
        return user
    }
}
