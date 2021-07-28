//
//  MainInteractor.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import Firebase
import Dispatch

final class MainInteractor
{
    private var _listeners = [ListenerRegistration]()
    
//    private var qosType = DispatchQoS.QoSClass.Type = .
}

// MARK: - Extensions -

extension MainInteractor: MainInteractorProtocol
{
    func removeAllData()
    {
        guard let r = DB.shared.getRealm else {
            return
        }

        try! r.write
        {
            r.deleteAll()
        }
    }
    
    func removeObservers()
    {
        for i in _listeners
        {
            i.remove()
        }
        
        _listeners = [ListenerRegistration]()
    }
    
    private func _saveTableData(tables: [[AnyHashable: Any]], isRemove: Bool)
    {
        var data = [TableModel]()
        
        for table in tables
        {
            guard
                let tableUid   = table["uid"] as? String,
                let typeString = table["type"] as? String,
                let partyName  = table["party_name"] as? String,
                let parameters = table["params"] as? [String: Any],
                let number   = Int(parameters["number"] as? String ?? ""),
                let seats    = Int(parameters["seats"] as? String ?? ""),
                let x        = Float(parameters["x"] as? String ?? ""),
                let y        = Float(parameters["y"] as? String ?? ""),
                let width    = Float(parameters["width"] as? String ?? ""),
                let height   = Float(parameters["height"] as? String ?? ""),
                let rotation = parameters["rotation"] as? Float
            else {
                continue
            }
                                
            let newTable = TableModel()
            newTable.uid = tableUid
            newTable.typeString = typeString
            newTable.partyName = partyName
            
            let tableParameters = TableModelParameters()
            tableParameters.uid = tableUid
            tableParameters.number   = number
            tableParameters.seats    = seats
            tableParameters.x        = x
            tableParameters.y        = y
            tableParameters.width    = width
            tableParameters.height   = height
            tableParameters.rotation = rotation
            newTable.parameters = tableParameters
            
            data.append(newTable)
        }
                
        DispatchQueue.main.async {
        
            if(data.count > 0)
            {
                guard let r = DB.shared.getRealm else {
                    return
                }
                
                let tables = r.objects(TableModel.self)
                
                try! r.write
                {
                    if(isRemove)
                    {
                        tables.forEach { item in
                            item.isRemoved = true
                        }
                    }
                    
                    r.add(data, update: .all)
                }
            }
        }
    }
        
    func syncTables(finish: @escaping (_ placeUID: String) -> (), updateTables: @escaping () -> ())
    {
        guard let r = DB.shared.getRealm, let placeUid = r.objects(UsersPlaceModel.self).first?.placeUid else {
            return
        }
        
//        Logger.log("*** placeUid: \(placeUid)")
//        let tables = r.objects(TableModel.self)
        
//        try! r.write
//        {
//            tables.forEach { item in
//                item.isRemoved = true
//            }
//        }

        DispatchQueue.global(qos: .utility).async {
            
            let db = DB.shared.getFirestore
            
            db.collection("objects")
                .whereField("place_uid", isEqualTo: placeUid)
                .getDocuments()
                { (data, err) in
    //                Logger.log("*** tables")
                    
                    guard let tablesData = data?.documents else {
    //                    Logger.log("!!! No tables")
                        return
                    }
                    
                    var data = [[AnyHashable: Any]]()
                    
    //                var tablesCount = (total: tablesData.count, bad: 0)
                    
                    for tableData in tablesData
                    {
                        let table = tableData.data()
                        data.append(table)

//                        self._saveTableData(table: table)
                        
                    }
                    
                    self._saveTableData(tables: data, isRemove: true)
                                                    
                    finish(placeUid)
                }
            
            //---
            
            let listener = db.collection("objects")
                .whereField("place_uid", isEqualTo: placeUid)
                .addSnapshotListener()
                { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("!!! Error fetching objects: \(error!)")
                        return
                    }
                    
//                    print("** UPDATE TABLES")
                    
                    var data = [[AnyHashable: Any]]()

                    for i in documents
                    {
                        let new_table = i.data()
                        
//                        print(new_table)
                        
                        data.append(new_table)
                    }
                    
                    self._saveTableData(tables: data, isRemove: false)
                    
                    updateTables()
                }
            
            self._listeners.append(listener)
        }
    }
    
    func syncMenuAll(finish: @escaping () -> ())
    {
        let dg = DispatchGroup()
        
        dg.enter()
        syncMenuCategories {
            dg.leave()
        }
        
        dg.enter()
        syncMenuItems {
            dg.leave()
        }
        
        dg.notify(queue: DispatchQueue.main) {
//            NotificationCenter.default.post(name: Notification.Name("MBRNotification.MenuReload"), object: nil)
            
            finish()
        }
    }
    
    func syncMenuItems(finish: @escaping () -> ())
    {
//        print("*** syncMenuItems")
        
        guard let r = DB.shared.getRealm, let placeUid = r.objects(UsersPlaceModel.self).first?.placeUid else {
            return
        }
        
//        Logger.log("*** placeUid: \(placeUid)")

        
        DispatchQueue.global(qos: .utility).async {
            let db = DB.shared.getFirestore
            
            db.collection("menu_items")
                .whereField("place_uid", isEqualTo: placeUid)
                .getDocuments()
            { (data, err) in
    //            Logger.log("*** menu_items")
                
                guard let menuItemsData = data?.documents else {
    //                Logger.log("!!! No menu_items")
                    return
                }
                
                var newItems = [MenuItemModel]()
                
                for itemData in menuItemsData
                {
                    let item = itemData.data()
                    
//                    print(item)
                    
                    let newItem = MenuItemModel()
                    newItem.CategoryUID = item["category_uid"] as? String ?? ""
                    newItem.Description = item["description"] as? String ?? ""
                    newItem.IsActive = Bool(item["is_active"] as? String ?? "") ?? true
                    newItem.IsHidden = Bool(item["is_hidden"] as? String ?? "") ?? false
                    newItem.PhotoURI = item["photo_uri"] as? String ?? ""
                    newItem.PlaceUID = item["place_uid"] as? String ?? ""
                    newItem.Price = Double(item["price"] as? String ?? "") ?? 0
                    newItem.Rating = Double(item["rating"] as? String ?? "") ?? 0
                    newItem.Title = item["title"] as? String ?? ""
                    newItem.Type = item["type"] as? String ?? ""
                    newItem.UID = item["uid"] as? String ?? ""
                    newItem.isRemoved = false
                    
                    //--
                    
                    newItem.Recipe = item["recipe"] as? String ?? ""
                    newItem.Ingredients = item["ingredients"] as? String ?? ""
                    newItem.CookingTime = item["cooking_time"] as? String ?? ""
                    newItem.Calories = item["calories"] as? String ?? ""
                    newItem.AlcoholDegrees = item["alcohol_degrees"] as? String ?? ""
                                                    
                    let modifiers = item["modifiers"] as? [[String: AnyHashable]] ?? []
                    
                    if(modifiers.count > 0)
                    {
                        newItem.IsModificators = true
                    }
                    
                    newItems.append(newItem)
                }
                    
                DispatchQueue.main.async { [weak self] in
                    
                    if(newItems.count > 0)
                    {
                        let menuItems = r.objects(MenuItemModel.self)
                        
                        try! r.write
                        {
                            menuItems.forEach { item in
                                item.isRemoved = true
                            }
                        }
                        
                        try! r.write
                        {
                            r.add(newItems, update: .all)
                        }
                    }
                    
                    finish()
                }
            }
                                
        }
    }
    
    func syncMenuCategories(finish: @escaping () -> ())
    {
//        print("*** syncMenuCategories")
        
        guard let r = DB.shared.getRealm,let placeUid = r.objects(UsersPlaceModel.self).first?.placeUid else {
            return
        }
        
//        Logger.log("*** placeUid: \(placeUid)")

        
        DispatchQueue.global(qos: .utility).async {
            let db = DB.shared.getFirestore
            
            db.collection("menu_categories")
            .whereField("place_uid", isEqualTo: placeUid)
            .getDocuments()
            { (data, err) in
    //            Logger.log("*** categories")
                
                guard let categoriesData = data?.documents else {
    //                Logger.log("!!! No categories")
                    return
                }
                
                var newData = [MenuCategoryModel]()
                
                for categoryData in categoriesData {
                    let category = categoryData.data()
                    
//                    print(category)
                    
                    let newmMenuCategory = MenuCategoryModel()
                    newmMenuCategory.Description = category["description"] as? String ?? ""
                    newmMenuCategory.PhotoURI =  category["photo_uri"] as? String ?? ""
                    newmMenuCategory.PlaceUID =  category["place_uid"] as? String ?? ""
                    newmMenuCategory.SortIndex =  Int(category["sort_index"] as? String ?? "") ?? 0
                    newmMenuCategory.Title =  category["title"] as? String ?? ""
                    newmMenuCategory.Type =  category["type"] as? String ?? ""
                    newmMenuCategory.UID =  category["uid"] as? String ?? ""
                    
                    newData.append(newmMenuCategory)
                }
                
                DispatchQueue.main.async { [weak self] in
                
                    if(newData.count > 0)
                    {
                        let categories = r.objects(MenuCategoryModel.self)
                        
                        try! r.write
                        {
                            categories.forEach { item in
                                item.isRemoved = true
                            }
                        }
                        
                        try! r.write
                        {
                            r.add(newData, update: .all)
                        }
                    }
                    
                    finish()
                    
                }
            }

        }
        
    }
    
    func syncUserData()
    {
//        print("*** syncUserData")
        
        guard let r = DB.shared.getRealm, let place = r.objects(UsersPlaceModel.self).first else {
            return
        }
        
        guard let user = r.objects(UserModel.self).first else {
            return
        }
        
        let dg = DispatchGroup()
                    
        let db = DB.shared.getFirestore
        
        var FirstName = ""
        var FullName = ""
        var LastName = ""
        var RoleName = ""
        
        dg.enter()
        db.collection("places")
            .document(place.placeUid)
            .getDocument()
            { (document, err) in

                guard let data = document?.data() else {
                    return
                }

                try! r.write
                {
                    place.Name = data["name"] as? String ?? ""
                    place.City = data["city"] as? String ?? ""
                    place.Address = data["address"] as? String ?? ""
                    place.Country = data["country"] as? String ?? ""
                    place.Currency = data["currency"] as? String ?? ""
                }
                
                dg.leave()
            }
        
        dg.enter()
        db.collection("roles")
            .document(place.roleUid)
            .getDocument()
            { (document, err) in
                guard let data = document?.data() else {
                    return
                }
                
                RoleName = data["title"] as? String ?? ""
                
                dg.leave()
            }
        
        dg.enter()
        db.collection("users")
            .document(place.userUid)
            .getDocument()
            { (document, err) in
                guard let data = document?.data() else {
                    return
                }
                
//                print("*** users")
//                print(data)
                
                FirstName = data["first_name"] as? String ?? ""
                FullName = data["full_name"] as? String ?? ""
                LastName = data["last_name"] as? String ?? ""
                
                
                dg.leave()
            }
        
        dg.notify(queue: DispatchQueue.main) {
            try! r.write
            {
                user.FirstName = FirstName
                user.FullName = FullName
                user.LastName = LastName
                user.RoleName = RoleName
            }
        }
    }
    
    func syncPlaces(finish: @escaping () -> ())
    {
        guard let r = DB.shared.getRealm, let userUid = r.objects(UserModel.self).first?.userUid else {
            return
        }
        
        DispatchQueue.global(qos: .utility).async {
            let db = DB.shared.getFirestore
            
            db.collection("users_places")
                .document(userUid)
                .getDocument()
                { (document, err) in
    //                Logger.log("*** users_places")
                    
                    var placesCount = (total: document?.data()?.count ?? 0, bad: 0)
                    
    //                print("*** users_places")
    //                print(document?.data())

                    guard
                        let usersPlaceFirstValue = document?.data()?.first?.value as? [String: Any],
                        let userUid   = usersPlaceFirstValue["user_uid"] as? String,
                        let placeUid  = usersPlaceFirstValue["place_uid"] as? String,
                        let roleUid   = usersPlaceFirstValue["role_uid"] as? String,
                        let colorName = usersPlaceFirstValue["color_name"] as? String,
                        let colorTag  = usersPlaceFirstValue["color_tag"] as? String,
                        let isActive  = usersPlaceFirstValue["is_active"] as? Bool
                    else {
                        placesCount.bad += 1
    //                    Logger.log("!!! No usersPlace")
                        return
                    }
                                    
                    let userPlace = UsersPlaceModel()
                    userPlace.userUid   = userUid
                    userPlace.placeUid  = placeUid
                    userPlace.roleUid   = roleUid
                    userPlace.colorName = colorName
                    userPlace.colorTag  = colorTag
                    userPlace.isActive  = isActive
                    
                    
                    DispatchQueue.main.async { [weak self] in
                        guard let r = DB.shared.getRealm else {
                            return
                        }


                        
                        try! r.write {
                            r.add(userPlace, update: .all)
                        }

                        finish()
                    }
                }
        }
        
//        Logger.log("*** userUid: \(userUid)")

        
    }
    
    func syncOrderItems(placeUid: String, finish: @escaping (_ uid: String, _ checkin_uid: String) -> ())
    {
        DispatchQueue.global(qos: .utility).async {
            
            let db = DB.shared.getFirestore
            
            db.collection("order_items")
                .whereField("place_uid", isEqualTo: placeUid)
                .whereField("status", in: ["new", "active", "ready"])
                .getDocuments()
                { (data, err) in
    //                Logger.log("*** order_items")
                    
                    guard let order_items_data = data?.documents else {
    //                    Logger.log("!!! No order_items")
                        return
                    }
                    
                    var dataToSave = [
                        [AnyHashable: Any]
                    ]()

                    for order_item_data in order_items_data
                    {
                        let order_item = order_item_data.data()
                        
                        dataToSave.append(order_item)
                    }
                    
                    self._prepareOrderItemAndSave(order_items: dataToSave, isRemove: true, finish: { (uid, checkinUID) in
                        finish(uid, checkinUID)
                    }, finishAll: {
                        
                    })

                }
            
            let listener = db.collection("order_items")
                .whereField("place_uid", isEqualTo: placeUid)
    //            .whereField("status", isEqualTo: "new")
                .addSnapshotListener()
                { (querySnapshot, error) in
    //                Logger.log("*** order_items Listener")
                    guard let documents = querySnapshot?.documents else {
                        print("!!! Error fetching order_items: \(error!)")
                        return
                    }

    //                Logger.log("*** order_items Listener documents count: \(documents.count) documents: \(documents)")

                    var dataToSave = [
                        [AnyHashable: Any]
                    ]()
                    
                    for i in documents
                    {
                        let order_item = i.data()
                        
                        dataToSave.append(order_item)
                    }
                    
                    self._prepareOrderItemAndSave(order_items: dataToSave, isRemove: false, finish: { (uid, checkinUID) in
                        finish(uid, checkinUID)
                    }, finishAll: {
                        
                    })
                }
            
            self._listeners.append(listener)
        }
    }
    
    private func _prepareOrderItemAndSave(order_items: [[AnyHashable: Any]], isRemove: Bool, finish: @escaping (_ uid: String, _ checkin_uid: String) -> (), finishAll: @escaping () -> ())
    {
//        print("*** _prepareOrderItemAndSave ")
//        print(order_item["fires_number"])
//        print(order_item["fires_number"] as? Int ?? 0)
        
        var data = [OrderItemModel]()
        
        for order_item in order_items
        {
            let newOderItem = OrderItemModel()
            newOderItem.CheckinUID = order_item["checkin_uid"] as? String ?? ""
            newOderItem.Comment = order_item["comment"] as? String ?? ""
            newOderItem.Denied = Bool(order_item["denied"] as? String ?? "") ?? false
            newOderItem.FiresNumber = order_item["fires_number"] as? Int ?? 0
            newOderItem.InvoiceUID = order_item["invoice_uid"] as? String ?? ""
            newOderItem.IsRemoved = false
            newOderItem.MenuItemUID = order_item["menu_item_uid"] as? String ?? ""
            newOderItem.PhotoURI = order_item["photo_uri"] as? String ?? ""
            newOderItem.PlaceUID = order_item["place_uid"] as? String ?? ""
            newOderItem.Priority = Int(order_item["priority"] as? String ?? "") ?? 0
            newOderItem.Price = Double(order_item["price"] as? String ?? "") ?? 0
            newOderItem.Status = order_item["status"] as? String ?? ""
            newOderItem.Title = order_item["title"] as? String ?? ""
            newOderItem.UID = order_item["uid"] as? String ?? ""
            
            data.append(newOderItem)
            
            finish(newOderItem.UID, newOderItem.CheckinUID)
        }
        
        DispatchQueue.main.async {
            
            if(data.count > 0)
            {
                guard let r = DB.shared.getRealm else {
                    return
                }
                
                let orders = r.objects(OrderItemModel.self)
                
                if(isRemove)
                {
                    try! r.write
                    {
                        orders.forEach { item in
                            item.IsRemoved = true
                        }
                    }
                }
                                                
                try! r.write
                {
                    r.add(data, update: .all)
                }
            }
            
            finishAll()
  
        }
    }
    
    func syncCheckins(placeUid: String, finish: @escaping (_ tableUID: String, _ checkinUID: String) -> (), finishAll: @escaping () -> ())
    {
//        Logger.log("*** checkinsTest placeUid: \(placeUid)")
        guard let r = DB.shared.getRealm else {
            return
        }
        

        
        DispatchQueue.global(qos: .utility).async {
            let db = DB.shared.getFirestore
            
            db.collection("checkins")
                .whereField("place_uid", isEqualTo: placeUid)
                .whereField("status", in: ["new", "approved"])
                .getDocuments()
                { (data, err) in
    //                Logger.log("*** checkins")
                    
                    guard let checkinsData = data?.documents else {
    //                    Logger.log("!!! No checkins")
                        return
                    }
                    
    //                var checkinsCount = (total: checkinsData.count, bad: 0)
                    
                    var dataToSave = [
                        [AnyHashable: Any]
                    ]()

                    for checkinData in checkinsData
                    {
                        let checkin = checkinData.data()
                        
                        dataToSave.append(checkin)
    //                    print("*** SYNC CHECKINS 1")
    //                    print(checkin)
                        
//                        self._prepareCheckinAndSave(checkin: checkin) { (tableUID, checkinUID) in
//                            finish(tableUID, checkinUID)
//                        }
                    }
                    
                    if(dataToSave.count > 0)
                    {
                        self._prepareCheckinAndSave(checkins: dataToSave, isRemove: true) { (tableUID, checkinUID) in
                            finish(tableUID, checkinUID)
                        } finishAll: {
                            finishAll()
                        }
                    }
                    else
                    {
                        finishAll()
                    }
                    
//                    finishAll()
                    
    //                Logger.log("*** Checkins total: \(checkinsCount.total), bad: \(checkinsCount.bad)")
                }
            
            let listener = db.collection("checkins")
                .whereField("place_uid", isEqualTo: placeUid)
    //            .whereField("status", isEqualTo: "new")
                .addSnapshotListener()
                { (querySnapshot, error) in
    //                Logger.log("*** checkinsListener")
                    guard let documents = querySnapshot?.documents else {
                        print("!!! Error fetching documents: \(error!)")
                        return
                    }
                    
                    var dataToSave = [
                        [AnyHashable: Any]
                    ]()

                    for i in documents
                    {
                        let checkin = i.data()
                        
                        dataToSave.append(checkin)
                    }
                    
                    if(dataToSave.count > 0)
                    {
                        self._prepareCheckinAndSave(checkins: dataToSave, isRemove: false) { (tableUID, checkinUID) in
                            finish(tableUID, checkinUID)
                        } finishAll: {
                            finishAll()
                        }
                    }
                    else
                    {
                        finishAll()
                    }
                    
                    
                }
            
            self._listeners.append(listener)
        }

    }
    
    private func _prepareCheckinAndSave(checkins: [[AnyHashable: Any]], isRemove: Bool, finish: @escaping (_ tableUID: String, _ checkinUID: String) -> (), finishAll: @escaping () -> ())
    {
        var data = [CheckinModel]()
        
        for checkin in checkins
        {
            guard
                let checkinUid    = checkin["uid"] as? String,
                let placeUid      = checkin["place_uid"] as? String,
                let number        = checkin["number"] as? Int,
                let tableUid      = checkin["object_uid"] as? String,
                let tableNumber   = checkin["object_number"] as? String,
                //let type          = checkin["type"] as? String,
                let status        = checkin["status"] as? String,
    //            let checkinTime   = (checkin["checkin_time"] as? Timestamp)?.dateValue(),
                //let checkoutDate  = checkin["checkout_date"] as? String,
                //let isGeoValid    = checkin["is_geo_valid"] as? String,
                //let userUid       = checkin["user_uid"],
                let guestNumber   = checkin["guest_number"] as? Int,
                //let guestName     = checkin["guest_name"] as? String,
                //let guestLastName = checkin["guest_last_name"] as? String,
                //let phone         = checkin["phone"] as? String,
                //let wayToTreat    = checkin["way_to_treat"] as? String,
                let leftToPay     = Double(checkin["left_to_pay"] as? String ?? ""),
                let payed         = Double(checkin["payed"] as? String ?? ""),
                let subTotal      = Double(checkin["sub_total"] as? String ?? ""),
                let total         = Double(checkin["total"] as? String ?? "")
            else {
    //            checkinsCount.bad += 1
                continue
            }
            
            let userUid       = checkin["user_uid"] as? String
            let guestName     = checkin["guest_name"] as? String
            let guestLastName = checkin["guest_last_name"] as? String
            let phone         = checkin["phone"] as? String
            
            let newCheckin = CheckinModel()
            newCheckin.checkinUid    = checkinUid
            newCheckin.placeUid      = placeUid
            newCheckin.number        = number
            newCheckin.tableUid      = tableUid
            newCheckin.tableNumber   = tableNumber
            newCheckin.status        = status
    //        newCheckin.checkinTime   = checkinTime
            newCheckin.userUid       = userUid
            newCheckin.guestNumber   = guestNumber
            newCheckin.guestName     = guestName
            newCheckin.guestLastName = guestLastName
            newCheckin.phone         = phone
            newCheckin.leftToPay     = leftToPay
            newCheckin.payed         = payed
            newCheckin.subTotal      = subTotal
            newCheckin.total         = total

            data.append(newCheckin)
            
            finish(tableUid, checkinUid)
        }
        

        
        DispatchQueue.main.async {
            
            if(data.count > 0)
            {
                guard let r = DB.shared.getRealm else {
                    return
                }
                
                if(isRemove)
                {
                    let checkins = r.objects(CheckinModel.self)
                    
                    try! r.write
                    {
                        checkins.forEach { item in
                            item.isRemoved = true
                        }
                    }
                }
                                                
                try! r.write
                {
                    r.add(data, update: .all)
                }
            }

            finishAll()
        }
//        
    }
}
