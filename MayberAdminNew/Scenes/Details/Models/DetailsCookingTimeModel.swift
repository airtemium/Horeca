//
//  DetailsCookingTimeModel.swift
//  MayberAdminNew
//
//  Created by Artem on 10.06.2021.
//

import Foundation

class DetailsCookingTimeModel: DetailBaseModel
{
    var CookingTime = ""
    
    init(cookingTime: String)
    {
        super.init()
        
        CellType = "cooking"
        
        CellHeight = 44
        
        CookingTime = cookingTime
    }
}
