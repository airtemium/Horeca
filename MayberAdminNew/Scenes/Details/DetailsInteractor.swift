//
//  MainInteractor.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation

final class DetailsInteractor
{
    private var _menuItemUID = ""
    
    init(menuItemUID: String)
    {
        _menuItemUID = menuItemUID
    }
}

// MARK: - Extensions -

extension DetailsInteractor: DetailsInteractorProtocol
{
    func GetNextItem() -> String
    {
        guard let r = DB.shared.getRealm, let item = getMenuItem() else { return "" }
        
        let items = r.objects(MenuItemModel.self).filter("CategoryUID = '\(item.CategoryUID)' AND isRemoved = false").sorted(byKeyPath: "Title", ascending: true)
        
        let idx = items.firstIndex { $0.UID == item.UID }
        
        if(idx! < items.count - 1)
        {
            return items[idx! + 1].UID
        }
        
        return ""
    }
    
    func GetPrevItem() -> String
    {
        guard let r = DB.shared.getRealm,  let item = getMenuItem() else { return "" }
        
        let items = r.objects(MenuItemModel.self).filter("CategoryUID = '\(item.CategoryUID)' AND isRemoved = false").sorted(byKeyPath: "Title", ascending: true)
        
        let idx = items.firstIndex { $0.UID == item.UID }
        
        if(idx! > 0)
        {
            return items[idx! - 1].UID
        }
        
        return ""
    }
    
    func setCurrentMenuItemUID(uid: String)
    {
        _menuItemUID = uid
    }
    
    func getItemsInCategory() -> Int
    {
        guard let r = DB.shared.getRealm, let item = getMenuItem() else { return 0 }
                
        return r.objects(MenuItemModel.self).filter("CategoryUID = '\(item.CategoryUID)' AND isRemoved = false").count
    }
    
    func getCurrentItemPositionInCategory() -> Int
    {
        guard let r = DB.shared.getRealm, let item = getMenuItem() else { return 0 }
        
        let items = r.objects(MenuItemModel.self).filter("CategoryUID = '\(item.CategoryUID)' AND isRemoved = false").sorted(byKeyPath: "Title", ascending: true)
        
        let idx = items.firstIndex { $0.UID == item.UID }
        
        return idx! + 1
    }
    
    func getMenuItem() -> MenuItemModel?
    {
//        print("*** DetailsInteractor getMenuItem \(_menuItemUID)")
        
        guard let r = DB.shared.getRealm else {
            return nil
        }
        
        guard let item = r.objects(MenuItemModel.self).filter("UID = '\(_menuItemUID)' AND isRemoved = false").first else { return nil }
        
//        print("*** DetailsInteractor getMenuItem 2")
        
        return item
    }
    
    func getCategory(uid: String) -> MenuCategoryModel?
    {
        guard let r = DB.shared.getRealm, let item = r.objects(MenuCategoryModel.self).filter("UID = '\(uid)' AND isRemoved = false").first else { return nil }
        
        return item
    }
    
    func getCurrentMenuItemUID() -> String
    {
        return _menuItemUID
    }
    
    
}
