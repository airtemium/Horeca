//
//  MainProtocols.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

protocol DetailsWireframeProtocol: WireframeProtocol
{
    func GoBack()
}

protocol DetailsViewProtocol: ViewProtocol
{
    
}

protocol DetailsPresenterProtocol: PresenterProtocol
{
    func getCurrentMenuItemUID() -> String
    
    func getItemsCount() -> Int
    
    func getDataItem(idx: Int) -> IDetailBaseModel
    
    func reloadData()
    
    func getItemsInCategory() -> Int
    
    func getCurrentItemPositionInCategory() -> Int
    
    func GoBack()
    
    func GetNextItem() -> String
    
    func GetPrevItem() -> String
    
    func setCurrentMenuItemUID(uid: String)
}

protocol DetailsInteractorProtocol: InteractorProtocol
{
    func getCurrentMenuItemUID() -> String
    
    func GetNextItem() -> String
    
    func GetPrevItem() -> String
    
    func setCurrentMenuItemUID(uid: String)
    
    func getMenuItem() -> MenuItemModel?
    
    func getCategory(uid: String) -> MenuCategoryModel?
    
    func getItemsInCategory() -> Int
    
    func getCurrentItemPositionInCategory() -> Int
}
