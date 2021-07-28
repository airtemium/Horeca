//
//  TestCodableModel.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation

import Foundation
import RealmSwift

class TopLiveItem: Object, Codable
{
    @objc dynamic var preview_url: String?
    
    @objc dynamic var url: String?
    
    enum CodingKeys: String, CodingKey {
        case preview_url, url
    }
}
