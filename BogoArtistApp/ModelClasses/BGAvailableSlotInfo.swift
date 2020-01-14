//
//  BGAvailableSlotInfo.swift
//  BogoUserApp
//
//  Created by Alejandro Moya on 06/08/2019.
//  Copyright © 2019 Mobiloitte. All rights reserved.
//

import Foundation
import ObjectMapper

struct BGAvailableSlotInfo: Mappable {
    
    var id: Int = -1
    var scheduleId: Int = -1
    var timeFrom: String = ""
    var timeTo: String = ""
    
    init() { }
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        scheduleId <- map["schedule_id"]
        timeFrom <- map["start_time"]
        timeTo <- map["end_time"]
    }
    
}
