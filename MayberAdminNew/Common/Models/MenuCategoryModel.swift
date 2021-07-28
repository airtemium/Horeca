//
//  MenuCategoryModel.swift
//  MayberAdminNew
//
//  Created by Airtemium on 28.05.2021.
//

import Foundation
import RealmSwift

class MenuCategoryModel: Object
{
    @objc dynamic var Description: String = ""
    
    @objc dynamic var PhotoURI: String = ""
    
    @objc dynamic var PlaceUID: String = ""
    
    @objc dynamic var SortIndex = 0
    
    @objc dynamic var Title: String = ""
    
    @objc dynamic var `Type`: String = ""
    
    @objc dynamic var UID: String = ""
            
    override static func primaryKey() -> String?
    {
        return "UID"
    }
    
    @objc dynamic var isRemoved: Bool = false
}
