//
//  OrderPayResponse.swift
//  MayberAdminNew
//
//  Created by Airtemium on 01.06.2021.
//

import Foundation

class OrderPayResponse: Codable
{
    var Description: String?
    
    var ErrorCode: String?
    
    var Status: String?
    
    var Payload: OrderPayPayloadResponse?
    
    enum CodingKeys: String, CodingKey
    {
        case Description = "description",
             ErrorCode = "error_code",
             Status = "status",
             Payload = "payload"
    }
}

class OrderPayPayloadResponse: Codable
{
    var InvoiceUID: String?
    
    var CheckinUID: String?
    
    enum CodingKeys: String, CodingKey
    {
        case InvoiceUID = "uid",
             CheckinUID = "checkin_uid"
    }
}

/*
 success({
     description = "";
     "error_code" = "";
     payload =     {
         "additional_payments" =         {
             "service_fee" = 0;
         };
         "checkin_uid" = "59721c59-e944-44ab-81db-9387d4be65d5";
         "item_uids" =         (
             "d5f694bf-2a76-405a-8c5c-fa804de5d7da",
             "a651c359-d856-43fe-a25a-f2cd595af740",
             "012a909b-6bd1-475c-8af5-d50a5a0983c0",
             "8a565382-1dce-482d-bfa7-eb54794f8cfa",
             "39220e18-2436-45fb-9745-2b1700814e69",
             "a5407c12-1220-473f-8a37-7c5b7b4f9db4"
         );
         "left_to_pay" = 2160;
         "left_unpaid" = 0;
         number = 1;
         paid = 0;
         "payed_by_cash" = 0;
         "payment_comment" = "";
         "payment_uids" = "<null>";
         "place_uid" = "5a493379-552d-4724-8ea9-e8880c0a72e2";
         sales =         {
         };
         "sub_total" = 2160;
         total = 2160;
         uid = "fd75f7cf-5377-4d15-a6db-53b389dd58e4";
         "user_uid" = "<null>";
     };
     status = SUCCESS;
 })
 */
