//
//  DetailsCaloriesModel.swift
//  MayberAdminNew
//
//  Created by Artem on 10.06.2021.
//

import Foundation

class DetailsCaloriesModel: DetailBaseModel
{
    var Calories: String = ""
    
    init(calories: String)
    {
        super.init()
        
        CellType = "calories"
        
        CellHeight = 44
        
        Calories = calories
    }
}
