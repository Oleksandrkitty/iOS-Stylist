//
//  BGRatingInfo.swift
//  BogoUserApp
//
//  Created by Alejandro Moya on 15/08/2019.
//  Copyright © 2019 Mobiloitte. All rights reserved.
//

import Foundation
import ObjectMapper

struct BGRatingInfo: Mappable {
    
    var reviewCount: Int = 0
    var rating: Float = 0
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        reviewCount <- map["count"]
        rating <- map["rating"]
    }

}
