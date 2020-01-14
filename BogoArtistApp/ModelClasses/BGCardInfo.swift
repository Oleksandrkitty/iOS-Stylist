//
//  BGCardInfo.swift
//  BogoUserApp
//
//  Created by Alejandro Moya on 22/08/2019.
//  Copyright © 2019 Mobiloitte. All rights reserved.
//

import Foundation
import ObjectMapper

struct BGCardInfo: Mappable {

    var id: String = ""
    var object: String = ""
    var addressCity: String?
    var addressCountry: String?
    var addressLine1: String?
    var addressLine1Check: String?
    var addressLine2: String?
    var addressState: String?
    var addressZip: String?
    var addressZipCheck: String?
    var brand: String?
    var country: String?
    var customer: String?
    var cvcCheck: String?
    var dynamicLast4: String?
    var expMonth: Int?
    var expYear: Int?
    var fingerprint: String?
    var funding: String?
    var last4: String?
    var name: String?
    var tokenizationMethod: String?
    

    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        object <- map["object"]
        addressCity <- map["address_city"]
        addressCountry <- map["address_country"]
        addressLine1 <- map["address_line1"]
        addressLine1Check <- map["address_line1_check"]
        addressLine2 <- map["address_line2"]
        addressState <- map["address_state"]
        addressZip <- map["address_zip"]
        addressZipCheck <- map["address_zip_check"]
        brand <- map["brand"]
        country <- map["country"]
        customer <- map["customer"]
        cvcCheck <- map["cvc_check"]
        dynamicLast4 <- map["dynamic_last4"]
        expMonth <- map["exp_month"]
        expYear <- map["exp_year"]
        fingerprint <- map["fingerprint"]
        funding <- map["funding"]
        last4 <- map["last4"]
        name <- map["name"]
        tokenizationMethod <- map["tokenization_method"]
    }
    
}
