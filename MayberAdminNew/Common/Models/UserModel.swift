//
//  MBRUser.swift
//  MayberAdminNew
//
//  Created by Airtemium on 28.05.2021.
//

import Foundation
import RealmSwift

class UserModel: Object, Codable
{
    @objc dynamic var userUid: String
    
    @objc dynamic var RoleName: String = ""
    
    @objc dynamic var LastName: String = ""
    
    @objc dynamic var FirstName: String = ""
    
    @objc dynamic var FullName: String = ""
    
    override static func primaryKey() -> String?
    {
        return "userUid"
    }
    
    enum CodingKeys: String, CodingKey {
        case userUid = "user_uid"
    }
}
