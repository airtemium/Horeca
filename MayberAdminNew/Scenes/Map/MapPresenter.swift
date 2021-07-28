//
//  MapPresenter.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import UIKit

enum MapMode: Int
{
    case Normal
    case Edit
}

final class MapPresenter
{

    private var _mode = MapMode.Normal
    
    // MARK: - Private properties -
    
    private unowned let view: MapViewProtocol
    
    private let interactor: MapInteractorProtocol
    
    private let wireframe: MapWireframeProtocol

    // MARK: - Lifecycle -

    init(view: MapViewProtocol, interactor: MapInteractorProtocol, wireframe: MapWireframeProtocol)
    {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
    
    var _id = ""
}

// MARK: - Extensions -
extension MapPresenter: MapPresenterProtocol
{
    func GetID() -> String
    {
        if(_id.isEmpty)
        {
            _id = UUID().uuidString
        }
        
        return _id
    }
    
    func getCode(table: String, completion: @escaping ((Int)?) -> ())
    {
        self.interactor.getCode(table: table) { code in
            completion(code)
        }
    }
        
    func getTable(uid: String) -> TableModel?
    {
        return self.interactor.getTable(uid: uid)
    }
    
    func getButtonDeleteId() -> Int
    {
        return 5001
    }
    
    func deleteTables(uids: [String], completitionSuccess: @escaping () -> (), completitionWithError: @escaping (String) -> ())
    {
        
        self.interactor.setTablesAsRemoved(uids: uids)
        
        self.interactor.deleteTables(uids: uids) {
            completitionSuccess()
        } completitionWithError: { error in
            completitionWithError(error)
        }
    }
    
    func saveTables(data: [TableView], completitionSuccess: @escaping () -> (), completitionWithError: @escaping (String) -> ())
    {                
        /*{
         "objects": [
           {
             "number": "string",
             "params": {
               "height": "string",
               "rotation": 0,
               "seats": "string",
               "width": "string",
               "x": "string",
               "y": "string"
             },
             "party_name": "string",
             "place_uid": "string",
             "type": "string",
             "uid": "string"
           }
         ],
         "place_uid": "string"
       }*/
        
        var placeUID = ""
        
        guard let r = DB.shared.getRealm else {
            return
        }
        
        let place = r.objects(UsersPlaceModel.self).first
        
        placeUID = place!.placeUid

        
        var _data: [Any] = [Any]()
        
        var lastNumber = 0
        

        var numbers = [Int]()
        
        for i in r.objects(TableModel.self)
        {
            numbers.append(i.parameters.number)
        }
        
        if(numbers.count > 0)
        {
            numbers.sort()
            
            lastNumber = numbers.last! + 1
        }
        
        
                
        for i in data
        {
            print("** SAVE TABLE *** \(i.table.parameters.nrotation) **** \(i.table.parameters.rotation)")
            
//            print(i.transform)
            
            let radians = atan2(i.Container.transform.b, i.Container.transform.a)
            let degrees = radians * 180 / .pi
            
            print(degrees)
            
            self.interactor.saveTablePosition(uid: i.table.uid, x: Float(i.frame.origin.x), y: Float(i.frame.origin.y), rotation: Float(degrees))
            
            _data.append([
                "number": (i.IsNew) ? "\(lastNumber)" : "\(i.table.parameters.number)",
                "party_name": i.table.partyName,
                "place_uid": (i.table.uid.isEmpty) ? placeUID : i.table.placeUid,
                "type": i.table.typeString,
                "uid": i.table.uid,
                "params": [
                    "height": "\(i.table.parameters.height)",
                    "rotation": Int(degrees),
                    "seats": "\(i.table.parameters.seats)",
                    "width": "\(i.table.parameters.width)",
                    "x": "\(Int(i.frame.origin.x))",
                    "y": "\(Int(i.frame.origin.y))"
                ]
            ])
            

            lastNumber = lastNumber + 1
            
        }
  
//        print(_data)
//
        self.interactor.saveTables(data: _data) {
            completitionSuccess()
        } completitionWithError: { error in
            completitionWithError(error)
        }

    }
    
    func setModeEdit()
    {
        _mode = .Edit
    }
    
    func setModeNormal()
    {
        _mode = .Normal
    }
    
    func getMode() -> MapMode
    {
        return _mode
    }
    
    func getEmptyTableByType(type: String) -> TableModel
    {
//        print("*** MapPresenter getEmptyTableByType \(type)")
        var width: Float = 0
        var height: Float = 0
        var number = 0

        switch(type)
        {
        case "SquareTwoPlaces":
            width = 140
            height = 140
            number = 2
            break
        case "CircleTwoPlaces":
            width = 140
            height = 140
            number = 2
            break
        case "SquareFourPlaces":
            width = 140
            height = 140
            number = 4
            break
        case "RectangleFourPlaces":
            width = 140
            height = 140
            number = 4
            break
        case "CircleFourPlaces":
            width = 140
            height = 140
            number = 4
            break
        case "RectangleSixPlaces":
            width = 160
            height = 140
            number = 6
            break
        case "CircleSixPlaces":
            width = 140
            height = 140
            number = 6
            break
        case "CircleEightPlaces":
            width = 140
            height = 140
            number = 8
            break
        case "RectangleEightPlaces2":
            width = 200
            height = 140
            number = 8
            break
        case "RectangleEightPlaces":
            width = 200
            height = 140
            number = 8
            break
        default:
            break
        }
        
        let newTable = TableModel()
        newTable.uid = ""
        newTable.typeString = type
        newTable.partyName = ""
        
        let tableParameters = TableModelParameters()
        tableParameters.uid = ""
        tableParameters.number = number
        tableParameters.seats = number
        tableParameters.x = 0
        tableParameters.y = 0
        tableParameters.width = width
        tableParameters.height = height
        tableParameters.rotation = 0
        newTable.parameters = tableParameters
        
        return newTable
    }
    
    func GoToProfile()
    {
        self.wireframe.switchToUserProfileController()
    }
    
    func getNewTables() -> [TableModel]
    {
        var _tables = [TableModel]()
        
        let t1 = TableModel()
        t1.typeString = "CircleTwoPlaces"
        
        let t9 = TableModel()
        t9.typeString = "SquareTwoPlaces"
        
        let t2 = TableModel()
        t2.typeString = "CircleFourPlaces"
        
        let t5 = TableModel()
        t5.typeString = "SquareFourPlaces"
        
        let t10 = TableModel()
        t10.typeString = "RectangleFourPlaces"
        
        let t3 = TableModel()
        t3.typeString = "CircleSixPlaces"
        
        let t6 = TableModel()
        t6.typeString = "RectangleSixPlaces"
        
        let t4 = TableModel()
        t4.typeString = "CircleEightPlaces"

        let t7 = TableModel()
        t7.typeString = "RectangleEightPlaces"
        
        let t8 = TableModel()
        t8.typeString = "RectangleEightPlaces2"

        _tables.append(t1)
        _tables.append(t2)
        _tables.append(t3)
        _tables.append(t4)
        _tables.append(t5)
        _tables.append(t6)
        _tables.append(t7)
        _tables.append(t8)
        _tables.append(t9)
        _tables.append(t10)
        
        return _tables
    }
    
    func getOrdersCount() -> Int
    {
        return self.interactor.getOrdersCount()
    }
    
    func getOorderAmount() -> Double
    {
        return self.interactor.getOorderAmount()
    }
    
    func getPlaceCurrency() -> String
    {
        return self.interactor.getPlaceCurrency()
    }
    
    func GoToOrders()
    {
        
    }
    
    func switchToUserProfileController() {
//        Logger.log("\(type(of: self))")
        wireframe.switchToUserProfileController()
    }
    
    func switchToOrdersController() {
//        Logger.log("\(type(of: self))")
        wireframe.switchToOrdersController()
    }
    
    func openTable(tableUid: String) {
//        Logger.log("\(type(of: self))")
        wireframe.openTable(tableUid: tableUid)
    }
    
    func openSeats(tableUid: String) {
//        Logger.log("\(type(of: self))")
        wireframe.openSeats(tableUid: tableUid)
    }
    
    func storeCode(_ code: Int, tableUid: String) {
        interactor.storeCode(code, tableUid: tableUid)
    }

    func getPlace() -> String {
        interactor.getPlace()
    }
    
//    func getCode(table: TableModel, completion: @escaping ((Int, Bool)?) -> ())
//    {
//        interactor.getCode(table: table, completion: completion)
//    }
    
    
    func getCode(table: TableModel) -> Bool
    {
        return interactor.getCode(table: table)
    }
    
    func getTables(placeUid: String, forced: Bool) -> [TableModel]
    {
        interactor.getTables(placeUid: placeUid, forced: forced)
    }
    
    func getCheckins() -> [CheckinModel]
    {
        interactor.getCheckins()
    }
    
    func getCheckin(tableUid: String, checkinUid: String) -> CheckinModel?
    {
        return interactor.getCheckin(tableUid: tableUid, checkinUid: checkinUid)
    }
}
