//
//  BGPaymentInfo.swift
//  BogoUserApp
//
//

import Foundation
import ObjectMapper

struct BGPaymentInfo: Mappable {

    var paymentDate = ""
    var bookingDate = ""
    var clientFirstName = ""
    var clientLastName = ""

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        paymentDate <- map["payment_date"]
        bookingDate <- map["booking_date"]
        clientFirstName <- map["client_first_name"]
        clientLastName <- map["client_last_name"]
    }

}
