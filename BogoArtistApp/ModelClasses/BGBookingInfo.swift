//
//  BGBookingInfo.swift
//  BogoUserApp
//
//  Created by Alejandro Moya on 16/08/2019.
//  Copyright © 2019 Mobiloitte. All rights reserved.
//

import Foundation
import ObjectMapper

enum BookingStatus: String {
    case pending = "pending",
    confirmed = "confirmed",
    rejected = "rejected",
    completed = "completed"
}

struct BGBookingInfo: Mappable, Equatable {
    
    var id: Int = -1
    var clientId: Int = -1
    var clientFullName: String = ""
    var stylist: BGStylistInfo?
    var serviceId: Int = -1
    var serviceName: String = ""
    var timeFrom: String = ""
    var timeTo: String = ""
    var serviceLat: String = ""
    var serviceLong: String = ""
    var date: String = ""
    var status: String = ""
    var availabilityId: Int = -1
    var fee: String = ""
    
    init() { }
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        clientId <- map["client_id"]
        clientFullName <- map["client_full_name"]
        stylist <- map["stylist"]
        serviceId <- map["service_id"]
        serviceName <- map["service_name"]
        timeFrom <- map["time_from"]
        timeTo <- map["time_to"]
        serviceLat <- map["service_lat"]
        serviceLong <- map["service_long"]
        date <- map["date"]
        status <- map["status"]
        availabilityId <- map["availability_id"]
        fee <- map["fee"]
    }
    
    static func == (lhs: BGBookingInfo, rhs: BGBookingInfo) -> Bool {
        return lhs.id == rhs.id
    }

    var stylistFullName: String {
        StringUtils.joinNullableStrings([
            stylist?.firstName,
            stylist?.lastName
        ])
    }

    var artistPic: URL? {
        URL(string: stylist?.image ?? "")
    }

}
