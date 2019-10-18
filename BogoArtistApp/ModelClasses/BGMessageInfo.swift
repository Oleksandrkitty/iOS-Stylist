//
//  BGMessageInfo.swift
//  BogoArtistApp
//
//

import UIKit

class BGMessageInfo: NSObject {

    var strUserImage    = String()
    var messageID       = ""
    var messageDate     = ""
    var message         = ""
    var senderImage     = ""
    var senderId        = ""
    var receiverId      = ""
    var convertedDate   = ""
    var sepratedTime    = ""
    var isSelfMessage   :Bool?

    /*
     Method to parse upcomming data.
     */
    class func getMessageList(list : Array<Dictionary<String, AnyObject>>) -> [BGMessageInfo] {
        var dummyArray = [BGMessageInfo]()
        
        for item in list {
            let obj = BGMessageInfo()
            obj.messageID = item.validatedValue("message_id", expected: "" as AnyObject) as! String
            obj.messageDate = item.validatedValue("message_date", expected: "" as AnyObject) as! String
            let arryaSeprator = obj.messageDate.components(separatedBy: " ")
            obj.sepratedTime = getTimeForMessageSend(time: arryaSeprator[1])
            obj.message = item.validatedValue("message", expected: "" as AnyObject) as! String
            obj.senderImage = item.validatedValue("senderImage", expected: "" as AnyObject) as! String
            obj.senderId = item.validatedValue("sender_id", expected: "" as AnyObject) as! String
            obj.receiverId = item.validatedValue("reciever_id", expected: "" as AnyObject) as! String
            obj.convertedDate = changeDateFormat(dateString: obj.messageDate) + " " + obj.sepratedTime
            if obj.senderId  == (UserDefaults.standard.value(forKey: pArtistID) as AnyObject) as! String{
                obj.isSelfMessage = true
            } else {
                obj.isSelfMessage = false
            }
            dummyArray.append(obj)
        }
        return dummyArray
    }
    
    class func changeDateFormat(dateString: String) -> String {
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
