//
//  TableOrder.swift
//  MayberAdminNew
//
//  Created by Airtemium on 25.05.2021.
//

import Foundation

enum TableOrderItemModelType: Int
{
    case Empty
    case Base
}

class TableOrderModel
{
    var Items = [TableOrderItemModel]()
    
    var TableUID = ""
    
    var CheckinUID = ""
    
    var Name = ""
    
    var GuestNumber = 0
    
    var TableNumber = 0
    
    var LeftToPay: Double = 0
    
    var Payed: Double = 0
    
    var Status = ""
    
    var TotalAmount: Double
    {
        get
        {
            Items.reduce(0) { $0 + $1.Cost }
        }
    }
    
    /// Флаг отвечающий за отображение ячейки ордера
    /// По дефолту видны все ячейки
    var isVisible: Bool = true
}

class TableOrderItemModel
{
    var `Type`: TableOrderItemModelType = .Base
    
    var Name = ""
        
    var Image = ""
    
    var Cost: Double = 0
    
    var Currency = ""
    
    var Status = ""
    
    var CheckinUID = ""
    
    var OrderItemUID = ""
    
    var MenuItemUID = ""
    
    var IsDenied = false
    
    var Fires = 0
    
    var itemDraggableType = ItemDraggableType.simple
}

enum ItemDraggableType {
    case simple
    case availableToDrop
}
