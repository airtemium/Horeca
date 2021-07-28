//
//  AnyOrderItem.swift
//  MayberAdminNew
//
//  Created by Artem on 03.06.2021.
//

import Foundation

class AnyOrderItem
{
    var CheckinUID: String = ""
    
    var OrderItemUID = ""
    
    init(checkinUID: String, orderItemUID: String)
    {
        CheckinUID = checkinUID
        OrderItemUID = orderItemUID
    }
}
