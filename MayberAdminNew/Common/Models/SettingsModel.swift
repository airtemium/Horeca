//
//  SettingsModel.swift
//  MayberAdminNew
//
//  Created by Airtemium on 01.06.2021.
//

import Foundation
import RealmSwift

class SettingsModel: Object
{
    @objc dynamic var Id: String = "1"
    
    override static func primaryKey() -> String?
    {
        return "Id"
    }
    
    @objc dynamic var AuthToken: String = ""
    
    @objc dynamic var UserUID: String = ""
    
    @objc dynamic var Email: String = ""
    
    @objc dynamic var Password = ""
}
