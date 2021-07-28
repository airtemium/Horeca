//
//  MBRUsersPlace.swift
//  MayberAdminNew
//
//  Created by Airtemium on 28.05.2021.
//

import Foundation
import RealmSwift

class UsersPlaceModel: Object
{
    @objc dynamic var userUid: String = ""
    
    @objc dynamic var placeUid: String = ""
    
    @objc dynamic var roleUid: String = ""
    
    @objc dynamic var colorName: String = ""
    
    @objc dynamic var colorTag: String = ""
    
    @objc dynamic var Name: String = ""
    
    @objc dynamic var Currency: String = ""
    
    @objc dynamic var Address: String = ""
    
    @objc dynamic var Country: String = ""
    
    @objc dynamic var City: String = ""
    
    @objc dynamic var isActive: Bool = false
    
    override static func primaryKey() -> String?
    {
        return "placeUid"
    }
}
