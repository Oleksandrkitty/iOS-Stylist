//
//  BGChatInfoModel.swift
//  BogoUserApp
//
//

import UIKit

class BGChatInfoModel: NSObject {
    
    //For Chat Detail
    var strUserImage : String = ""
    var strUserId : String = ""
    var strArtistFirstName : String = ""
    var strArtistLastName : String = ""

    var isClear: Bool?
    var isNotificationEnabled :Bool?
    var isNewInContact :Bool?
    var isSelfMessage :Bool?
    var isNewMessage :Bool?
    var strMessageText : String = ""
    var strMessageImageUrl : String = ""
    var strMessageTimeStamp : String = ""
    var strMessageDate : String = ""
    var strMessageTime : String = ""
    var userContactListArray = [BGChatInfoModel]()
    var userContactRequestListArray = [BGChatInfoModel]()
    var chatListArray = [BGChatInfoModel]()
    var chatListTempArray = [BGChatInfoModel]()
    var strBookingId : String = ""
    var strArtistId : String = ""
    var strArtistPic : String = ""

    
    
    class func getChatList(responseDict : Dictionary<String, AnyObject>?) -> BGChatInfoModel {
        let objSection = BGChatInfoModel()
        objSection.strUserId = responseDict?.validatedValue("sender_id", expected: "" as AnyObject) as! String
        objSection.strArtistId = responseDict?.validatedValue("reciever_id", expected: "" as AnyObject) as! String
        objSection.strMessageText = responseDict?.validatedValue("message", expected: "" as AnyObject) as! String
        objSection.strMessageDate = responseDict?.validatedValue("message_date", expected: "" as AnyObject) as! String
        
        objSection.strMessageDate = objSection.changeDateFormat(dateString: objSection.strMessageDate)
       // print(objSection.strMessageDate)
        
        if objSection.strUserId == currentUserId() {
            objSection.isSelfMessage = true
        } else {
            objSection.isSelfMessage = false

        }
        
        return objSection
    }
    
    func changeDateFormat(dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: dateString)
        formatter.dateFormat = "MMM dd, yyyy HH:mm a"
        if date != nil{
            return formatter.string(from: date!)
        }else{
            return ""
        }
    }

    override init() {
        
    }

    init(messageInfo message: BGMessageInfo) {
        self.strMessageText = message.text
        // todo copy another fields
    }

}
