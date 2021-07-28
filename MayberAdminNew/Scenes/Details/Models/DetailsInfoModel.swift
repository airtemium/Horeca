//
//  DetailRecipeModel.swift
//  MayberAdminNew
//
//  Created by Artem on 10.06.2021.
//

import Foundation
import UIKit

class DetailInfoModel: DetailBaseModel
{
    var Info = ""
    
    var _width: CGFloat = 0
    
    var _height: CGFloat = 0
    
    init(info: String)
    {
        super.init()
        
        CellType = "info"
        
        let sizes = self.CalculateTextSize(text: info, fontSize: 17, width: ScreenSize.SCREEN_WIDTH - 32 - 48)
        
        _width = sizes.width
        
        _height = sizes.height
        
        CellHeight = sizes.height + 24
        
        Info = info
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
