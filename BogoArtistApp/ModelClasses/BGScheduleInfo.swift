//
//  BGScheduleInfo.swift
//  BogoUserApp
//
//  Created by Alejandro Moya on 06/08/2019.
//  Copyright © 2019 Mobiloitte. All rights reserved.
//

import Foundation
import ObjectMapper

struct BGScheduleInfo: Mappable, Equatable {
    
    var id: Int = -1
    var stylistId: Int = -1
    var serviceIds: [Int] = []
    var date: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        stylistId <- map["stylist_id"]
        serviceIds <- map["service_ids"]
        date <- map["date"]
    }

}

