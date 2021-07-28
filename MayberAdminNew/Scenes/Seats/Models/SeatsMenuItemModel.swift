//
//  SeatsMenuItemModel.swift
//  MayberAdminNew
//
//  Created by Airtemium on 30.05.2021.
//

import Foundation

enum SeatsMenuItemType
{
    case Item
    case Category
    case DrinkCategory
    case None
}

class SeatsMenuItemModel
{
    var PhotoURI: String = ""
    
    var SortIndex = 0
    
    var Title: String = ""
    
    var UID: String = ""
    
    var `Type`: SeatsMenuItemType = .None
    
    var CategoryUID: String = ""
    
    var Price: Double = 0
    
    var MenuItemType = ""
}
