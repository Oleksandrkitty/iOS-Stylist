//
//  BGServiceInfo.swift
//  BogoUserApp
//
//  Created by Alejandro Moya on 31/07/2019.
//  Copyright © 2019 Mobiloitte. All rights reserved.
//

import Foundation
import ObjectMapper

struct BGServiceInfo: Mappable {
    
    var id: Int?
    var name: String = ""
    var serviceTypeId: Int = 0
    var serviceType: String = ""
    var amount: String = ""
    var duration: Int?
    var status: String = ""
    var image: String?
    
    init() { }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        serviceType <- map["service_type_id"]
        serviceType <- map["service_type"]
        amount <- map["amount"]
        duration <- map["duration"]
        status <- map["status"]
        image <- map["image"]
    }
    
}
