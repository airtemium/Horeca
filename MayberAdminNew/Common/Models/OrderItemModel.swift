//
//  OrderModel.swift
//  MayberAdminNew
//
//  Created by Airtemium on 20.05.2021.
//

import Foundation
import RealmSwift

class OrderItemModel: Object/*, Codable*/
{
    override static func primaryKey() -> String?
    {
        return "UID"
    }
    
    @objc dynamic var UID = ""
    
    @objc dynamic var Title = ""
    
    @objc dynamic var CheckinUID = ""
    
    @objc dynamic var InvoiceUID = ""
    
    @objc dynamic var MenuItemUID = ""
    
    @objc dynamic var PlaceUID = ""
    
    @objc dynamic var PhotoURI = ""
    
    @objc dynamic var Priority = 0
    
    @objc dynamic var FiresNumber = 0
    
    @objc dynamic var Denied = false
    
    @objc dynamic var Price: Double = 0
    
    @objc dynamic var Status = ""
    
    @objc dynamic var Comment = ""
    
    @objc dynamic var ApprovedAt: Int64 = 0
    
    @objc dynamic var CreatedAt: Int64 = 0
    
    @objc dynamic var ConfirmedAt: Int64 = 0
    
    @objc dynamic var ClosedAt: Int64 = 0
    
    @objc dynamic var OpenedAt: Int64 = 0
    
    @objc dynamic var UpdatedAt: Int64 = 0
    
    @objc dynamic var ReadyAt: Int64 = 0
    
    //---
    
    @objc dynamic var IsRemoved = false
    
    var isNew = false
    
//    enum CodingKeys: String, CodingKey
//    {
//        case UID = "uid", Title = "title", CheckinUID = "checkin_uid", Priority = "priority", Denied = "denied", FiresNumber = "fires_number",
//             InvoiceUID = "invoice_uid", MenuItemUID = "menu_item_uid", PlaceUID = "place_uid", PhotoURI = "photo_uri", Price = "price",
//             Status = "status", ApprovedAt = "approved_at", CreatedAt = "created_at", ConfirmedAt = "confirmed_at", ClosedAt = "closed_at",
//             OpenedAt = "opened_at", UpdatedAt = "updated_at", ReadyAt = "ready_at", Comment = "comment"
//    }
}
