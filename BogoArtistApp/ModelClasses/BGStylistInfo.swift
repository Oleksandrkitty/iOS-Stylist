//
//  BGStylistInfo.swift
//  BogoUserApp
//
//

import UIKit
import ObjectMapper

struct BGStylistInfo: Mappable, Equatable {
    
    var id: Int = -1
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var phone: String = ""
    var lat: String?
    var long: String?
    var image: String = ""
    var ratingInfo: BGRatingInfo?
    var favorite: Bool = false
    var payments: String = ""
    var earnings: String = ""

    init() {}
    
    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id <- map["id"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        email <- map["email"]
        phone <- map["phone"]
        lat <- map["lat"]
        long <- map["long"]
        image <- map["image"]
        ratingInfo <- map["reviews"]
        favorite <- map["is_favorite"]
        payments <- map["total_payments"]
        earnings <- map["total_earning"]
    }

    static func == (lhs: BGStylistInfo, rhs: BGStylistInfo) -> Bool {
        return lhs.id == rhs.id
    }

    
    
    //Old object definition
    /*var name = ""
    var email = ""
    var parlorName = ""
    var service = ""
    var message = ""
    var errorRowNumber = 100
    var errorMessage = ""
    var phoneNumber = ""
    var experiance = ""
    var isSmartPhone : Bool = false
    var isLicensed : Bool = false
    var isTransportation : Bool = false
    
    var cardId = ""
    var cardNumber = ""
    var dummyCardNumber = ""
    var dateExpiry = ""
    var cvvNumber = ""
    var holderName = ""
    var isCardSelect : Bool = false
    
    //Category
    
    var categoryId = ""
    var category = ""
    var categoryPrice = ""
    var categoryImage : UIImage?
    var subCategory = ""
    var subCategoryImage : UIImage?
    
    class func modelFromDict(_ infoDict:Dictionary<String, AnyObject>?) -> BGStylistInfo{
        
        let obj = BGStylistInfo()
        
        obj.cardId = infoDict?.validatedValue("card_id", expected: "" as AnyObject) as! String
        obj.holderName = infoDict?.validatedValue("carHolderName", expected: "" as AnyObject) as! String
        obj.cardNumber = infoDict?.validatedValue("carNumber", expected: "" as AnyObject) as! String
        obj.dummyCardNumber = obj.updateCardNumber(number: obj.cardNumber)
        obj.dateExpiry = infoDict?.validatedValue("carExpiry", expected: "" as AnyObject) as! String
        obj.cvvNumber = infoDict?.validatedValue("carCvv", expected: "" as AnyObject) as! String
        
        return obj
    }
    
    func updateCardNumber(number : String) -> String{
        
        if number.length == 19 {
            let arr = number.components(separatedBy: "-")
            return "\(arr[0])-****-****-\(arr[3])"
        }else if number.length == 16 {
            var start = number.startIndex
            let str1 = number[start..<number.index(start, offsetBy: 4)]
            start = number.index(start, offsetBy: 12)
            let str2 = number[start..<number.index(start, offsetBy: 4)]
            return "\(str1)-****-****-\(str2)"
           // return number
        }else{
            return number
        }
    }*/
}
