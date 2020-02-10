//
//  BGUserInfo.swift
//  BogoDemo
//
//

import UIKit
import ObjectMapper

struct BGUserInfo: Mappable {

    
    var userID = ""
    var email = ""
    var password = ""
    var lastName = ""
    var firstName = ""
    var phoneNumber = ""
    var profilePicUrl = ""
    var profilePic : UIImage?
    var confirmPassword = ""
    var socialId = ""
    var errorRowNumber = 100
    var errorMessage = ""
    
    init() { }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        userID <- (map["id"], TransformOf<String, Int>(fromJSON: { String($0!) }, toJSON: { $0.map { Int($0)! } }))
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        phoneNumber <- map["phone"]
        profilePicUrl <- map["image"]
        email <- map["email"]
    }

    
    
    static func fromJWTToken(token: String? = UserDefaults.standard.string(forKey: kAuthToken)) throws -> BGUserInfo {
        if let token = token {
            let userJson = try token.decodeJWTPart()
            var user = BGUserInfo()
            user.userID = userJson["id"].stringValue
            user.firstName = userJson["first_name"].stringValue
            user.profilePicUrl = userJson["profile_pic"].stringValue
            return user
        } else {
            throw NSError(domain: "TokenNotAvailable", code: 1, userInfo: nil)
        }
    }
    
}
