//
//  DetailRecipeModel.swift
//  MayberAdminNew
//
//  Created by Artem on 10.06.2021.
//

import Foundation
import UIKit

class DetailRecipeModel: DetailBaseModel
{
    var Recipe = ""
    
    var _width: CGFloat = 0
    
    var _height: CGFloat = 0
    
    init(recipe: String)
    {
        super.init()
        
        CellType = "recipe"
        
        var sizes = self.CalculateTextSize(text: recipe, fontSize: 17, width: ScreenSize.SCREEN_WIDTH - 32 - 48)
        
        _width = sizes.width
        
        _height = sizes.height
        
        CellHeight = sizes.height + 24
        
        Recipe = recipe
    }
    
    var Width: CGFloat
    {
        get
        {
            return _width
        }
    }
    
    var Height: CGFloat
    {
        get
        {
            return _height
        }
    }
}
