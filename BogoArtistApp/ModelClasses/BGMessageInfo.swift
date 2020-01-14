//
//  BGRatingInfo.swift
//  BogoUserApp
//
//  Created by Alejandro Moya on 15/08/2019.
//  Copyright © 2019 Mobiloitte. All rights reserved.
//

import Foundation
import ObjectMapper

struct BGMessageInfo: Mappable {

    var id = ""
    var booking_id: Int = 0
    var client: BGUserInfo?
    var stylist: BGStylistInfo?
    var text = ""
    var created_at = ""
    var sender = ""
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        booking_id <- map["booking_id"]
        client <- map["client"]
        stylist <- map["stylist"]
        text <- map["text"]
        created_at <- map["created_at"]
        sender <- map["sender"]
    }

    static func changeDateFormat(dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: dateString)
        formatter.dateFormat = "MMM dd, yyyy"
        if date != nil{
            return formatter.string(from: date!)
        }else{
            return ""
        }
    }
}
