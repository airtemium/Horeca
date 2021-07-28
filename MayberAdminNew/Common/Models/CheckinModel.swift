//
//  MBRCheckin.swift
//  MayberAdminNew
//
//  Created by Airtemium on 28.05.2021.
//

import Foundation
import RealmSwift

class CheckinModel: Object
{
    @objc dynamic var checkinUid: String = ""
    @objc dynamic var placeUid: String = ""
    @objc dynamic var number: Int = 0

    @objc dynamic var tableUid: String = ""
    @objc dynamic var tableNumber: String = ""

    @objc dynamic var status: String = ""
    @objc dynamic var checkinTime: Date = Date(timeIntervalSinceReferenceDate: 0)

    @objc dynamic var userUid: String?
    @objc dynamic var guestNumber: Int = 0
    @objc dynamic var guestName: String?
    @objc dynamic var guestLastName: String?
    @objc dynamic var phone: String?

    @objc dynamic var leftToPay: Double = 0
    @objc dynamic var payed: Double = 0
    @objc dynamic var subTotal: Double = 0
    @objc dynamic var total: Double = 0
    
    @objc dynamic var isRemoved: Bool = false
    
    var isNew = false

    /*
    let checkinUid    = checkin["uid"] as? String,
    let placeUid      = checkin["place_uid"] as? String,
    let number        = checkin["number"] as? Int,
    let tableUid      = checkin["object_uid"] as? String,
    let objectNumber  = checkin["object_number"] as? String,
    //let type          = checkin["type"] as? String,
    let status        = checkin["status"] as? String,
    let checkinTime   = (checkin["checkin_time"] as? Timestamp)?.dateValue(),
    //let checkoutDate  = checkin["checkout_date"] as? String,
    //let isGeoValid    = checkin["is_geo_valid"] as? String,
    //let userUid       = checkin["user_uid"],
    let guestNumber   = checkin["guest_number"] as? Int,
    //let guestName     = checkin["guest_name"] as? String,
    //let guestLastName = checkin["guest_last_name"] as? String,
    //let phone         = checkin["phone"] as? String,
    //let wayToTreat    = checkin["way_to_treat"] as? String,
    let leftToPay     = checkin["left_to_pay"] as? String,
    let payed         = checkin["payed"] as? String,
    let subTotal      = checkin["sub_total"] as? String,
    let total         = checkin["total"] as? String
    */

    override static func primaryKey() -> String?
    {
        return "checkinUid"
    }
}
