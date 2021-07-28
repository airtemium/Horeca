//
//  MainPresenter.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation

final class DetailsPresenter
{
    // MARK: - Private properties -
    
    private var _data = [IDetailBaseModel]()

    private unowned let view: DetailsViewProtocol
    
    private let interactor: DetailsInteractorProtocol
    
    private let wireframe: DetailsWireframeProtocol

    // MARK: - Lifecycle -

    init(view: DetailsViewProtocol, interactor: DetailsInteractorProtocol, wireframe: DetailsWireframeProtocol)
    {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -
extension DetailsPresenter: DetailsPresenterProtocol
{
    func GetNextItem() -> String
    {
        return self.interactor.GetNextItem()
    }
    
    func GetPrevItem() -> String
    {
        return self.interactor.GetPrevItem()
    }
    
    func setCurrentMenuItemUID(uid: String)
    {
        self.interactor.setCurrentMenuItemUID(uid: uid)
    }
    
    func GoBack()
    {
        self.wireframe.GoBack()
    }
    
    func getItemsInCategory() -> Int
    {
        return self.interactor.getItemsInCategory()
    }
    
    func getCurrentItemPositionInCategory() -> Int
    {
        return self.interactor.getCurrentItemPositionInCategory()
    }
    
    func reloadData()
    {
//        print("*** DetailsPresenter reloadData")
        
        _data = [IDetailBaseModel]()
        
        guard let r = DB.shared.getRealm, let place = r.objects(UsersPlaceModel.self).first else {
            return
        }
        
        guard let item = self.interactor.getMenuItem() else { return }
        
        guard let category = self.interactor.getCategory(uid: item.CategoryUID) else { return }
        
        _data.append(DetailCoverModel(categoryName: category.Title, categoryUID: category.UID, itemName: item.Title, itemUID: item.UID, price: item.Price, currency: place.Currency, image: item.PhotoURI))
        
        
        _data.append(DetailBaseModel())
        
        if(item.IsModificators)
        {
            _data.append(DetailsModifiersModel())
        }
        
        if(!item.Recipe.isEmpty)
        {
            _data.append(DetailRecipeModel(recipe: item.Recipe))
        }
        
        if(!item.Description.isEmpty)
        {
            _data.append(DetailInfoModel(info: item.Description))
        }
        
        if(!item.CookingTime.isEmpty)
        {
            _data.append(DetailsCookingTimeModel(cookingTime: item.CookingTime + " min."))
        }
        
        if(!item.Calories.isEmpty)
        {
            _data.append(DetailsCaloriesModel(calories: item.Calories))
        }
    }
    
    func getDataItem(idx: Int) -> IDetailBaseModel
    {
        return _data[idx]
    }
    
    func getCurrentMenuItemUID() -> String
    {
        return self.interactor.getCurrentMenuItemUID()
    }
    
    func getItemsCount() -> Int
    {
        return _data.count
    }
}
