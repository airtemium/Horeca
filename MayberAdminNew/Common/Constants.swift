
//  Created by Airtemium on 18.05.2021.
//
import Foundation
import UIKit

struct Constants
{
    struct API
    {
        static let Test = "Test"
    }
    
    struct Notify
    {
        static let UserUid = Notification.Name("MBRNotification.UserUid")
        
        static let UserUidRemove = Notification.Name("MBRNotification.UserUidRemove")
        
        static let UserPlace = Notification.Name("MBRNotification.UserPlace")
        
        static let Tables = Notification.Name("MBRNotification.Tables")
        
        
        
        //CheckinsAll
        
        static let Checkins = Notification.Name("MBRNotification.Checkins")
        
        static let CheckinsAll = Notification.Name("MBRNotification.CheckinsAll")
        
        static let Menu = Notification.Name("MBRNotification.MenuReload")
        
        static let OrderItem = Notification.Name("MBRNotification.OrderItem")
        
        static let OrderConfirmItems = Notification.Name("MBRNotification.OrderConfirmItems")
        
        static let OrderResetConfirmItems = Notification.Name("MBRNotification.OrderResetConfirmItems")
        
        static let DetailsAddMenuItem = Notification.Name("MBRNotification.DetailsAddMenuItem")
        
        static let AppBackground = Notification.Name("MBRNotification.AppBackground")
        
        static let AppForeground = Notification.Name("MBRNotification.AppForeground")
        
        static let ChangeController = Notification.Name("MBRNotification.ChangeController")
        
        static let RemoveController = Notification.Name("MBRNotification.RemoveController")
    }
    
    enum OrderItemStatus: String
    {
        case New = "new"
        case Active = "active"
        case Ready = "ready"
        case Closed = "closed"
        case Canceled = "canceled"
        case Confirmed = "confirmed"
    }
}
