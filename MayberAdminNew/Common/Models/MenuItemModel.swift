//
//  MenuItemModel.swift
//  MayberAdminNew
//
//  Created by Airtemium on 28.05.2021.
//

import Foundation
import RealmSwift

class MenuItemModel: Object
{
    @objc dynamic var isRemoved: Bool = false
    
    override static func primaryKey() -> String?
    {
        return "UID"
    }
    
    @objc dynamic var UID: String = ""
    
    @objc dynamic var PlaceUID: String = ""
    
    @objc dynamic var CategoryUID: String = ""
    
    @objc dynamic var Description: String = ""
    
    @objc dynamic var IsActive = false
    
    @objc dynamic var IsHidden = false
    
    @objc dynamic var PhotoURI: String = ""
    
    @objc dynamic var Title: String = ""
    
    @objc dynamic var `Type`: String = ""
    
    @objc dynamic var Price: Double = 0
    
    @objc dynamic var Rating: Double = 0
    
    //---
    
    @objc dynamic var Recipe: String = ""
    
    @objc dynamic var Ingredients: String = ""
    
    @objc dynamic var CookingTime: String = ""
    
    @objc dynamic var Calories: String = ""
    
    @objc dynamic var AlcoholDegrees: String = ""
    
    @objc dynamic var IsModificators: Bool  = false
}
