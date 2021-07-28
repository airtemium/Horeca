//
//  DetailBaseModel.swift
//  MayberAdminNew
//
//  Created by Artem on 09.06.2021.
//

import Foundation
import UIKit

protocol IDetailBaseModel
{
    func getType() -> String
    
    func getHeight() -> CGFloat        
}

class DetailBaseModel: IDetailBaseModel
{    
    var CellType = "base"
    
    var CellHeight: CGFloat = 44

    func getType() -> String
    {
        return CellType
    }
    
    func getHeight() -> CGFloat
    {
        return CellHeight
    }
    
    func CalculateTextSize(text: String, fontSize: CGFloat, width: CGFloat, height: CGFloat = 0) -> CGSize
    {
        return getLabelSize(str: text, size: fontSize, isBold: false, setWidth: width, setHeight: height)
    }
}
