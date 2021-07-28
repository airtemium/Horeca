//
//  DetailCoverModel.swift
//  MayberAdminNew
//
//  Created by Artem on 09.06.2021.
//

import Foundation

class DetailCoverModel: DetailBaseModel
{
    var Image = ""
    
    var CategoryName = ""
    
    var CategoryUID = ""
    
    var ItemName = ""
    
    var ItemUID = ""
    
    var Price: Double = 0
    
    var Currency = ""
    
    init(categoryName: String, categoryUID: String, itemName: String, itemUID: String, price: Double, currency: String, image: String)
    {
        super.init()
        
        CellType = "cover"
        
        CellHeight = 394
        
        Image = image
        
        CategoryName = categoryName
        
        CategoryUID = categoryUID
        
        ItemName = itemName
        
        ItemUID = itemUID
        
        Price = price
        
        Currency = currency
    }
}
