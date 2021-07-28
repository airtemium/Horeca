//
//  MBRResponse.swift
//  MayberAdminNew
//
//  Created by Airtemium on 28.05.2021.
//

import Foundation

struct ResponseModel<T: Codable>: Codable
{
    let status: String
    let errorCode: String
    let description: String
    let payload: T
    //"{\"status\":\"SUCCESS\",\"error_code\":\"\",\"description\":\"\",\"payload\":{\"user_uid\":\"vyMOrPK8eWMtDoRoqueqD5DrU2i2\"}}"
    
    enum CodingKeys: String, CodingKey {
        case status
        case errorCode = "error_code"
        case description
        case payload
    }
}
