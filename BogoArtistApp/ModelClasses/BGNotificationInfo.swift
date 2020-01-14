//
//  BGNotificationInfo.swift
//  BogoUserApp
//
//  Created by Alejandro Moya on 12/08/2019.
//  Copyright © 2019 Mobiloitte. All rights reserved.
//

import Foundation
import ObjectMapper

struct BGNotificationInfo: Mappable {
    
    var id: Int = -1
    var message: String = ""
    var createdAt: String = ""
    var bookingId: String?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        message <- map["message"]
        createdAt <- map["created_at"]
        bookingId <- map["booking_id"]
    }
    
}
