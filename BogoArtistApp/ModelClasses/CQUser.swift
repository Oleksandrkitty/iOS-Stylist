//
//  CQUser.swift
//  CabQ
//
//

import UIKit

class CQUser: NSObject {
    
    var userId          = ""
    var name            = ""
    var email           = ""
    var password        = ""
    var mobileNo        = ""
    var gender          = ""
    var dob             = ""
    var firstName       = ""
    var lastName        = ""
    
    class func user(_ infoDict: Dictionary<String, AnyObject>?) -> CQUser {
        let info = CQUser()
        if let userDict = infoDict {
            info.userId = "\(userDict.validatedValue("key", expected: "" as AnyObject))"
            info.name = "\(userDict.validatedValue("key", expected: "" as AnyObject))"
            info.email = "\(userDict.validatedValue("email", expected: "" as AnyObject))"
        }
        return info
    }
}
