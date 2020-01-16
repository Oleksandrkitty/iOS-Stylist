//
//  BGUserInfoModal.swift
//  BOGOArtistApp
//
//

import UIKit

class BGUserInfoModal: NSObject {

    var firstName                   = ""
    var lastName                    = ""
    var email                       = ""
    var password                    = ""
    var confirmPassword             = ""
    var validationLabel             = ""
    var id                          = ""
    var profileImage                : UIImage?
    var profileImageUrl             = ""
    var collectionProfileImage      : UIImage!
    var profileName                 = ""
    var artistDescription           = ""
    var welcomeKit                  = ""
    var phone                       = ""
    var longitude                   = ""
    var latitude                    = ""
    var reviewCount                 = ""
    var rating                      = ""
    var galleryArray                = NSMutableArray()
    var galleryIdArray              = Array<String>()
    var galImage                    = ""
    var galId                       = ""
    var addImage                    : UIImage?
    /*
     Method to parse upcomming data.
     */
    
    /*
  class func getProfileData(list: Dictionary<String, AnyObject>) -> BGUserInfoModal{
        let obj = BGUserInfoModal()
        obj.firstName = list.validatedValue("arFname", expected: "" as AnyObject) as! String
        obj.lastName = list.validatedValue("arLname", expected: "" as AnyObject) as! String
        obj.artistDescription = list.validatedValue("arDesc", expected: "" as AnyObject) as! String
        obj.email = list.validatedValue("arEmail", expected: "" as AnyObject) as! String
        obj.welcomeKit = list.validatedValue("arWelcomeKit", expected: "" as AnyObject) as! String
        obj.phone = list.validatedValue("arPhoneNo", expected: "" as AnyObject) as! String
        obj.profileImageUrl = list.validatedValue("arProfileImage", expected: "" as AnyObject) as! String
        obj.latitude = list.validatedValue("arLat", expected: "" as AnyObject) as! String
        obj.longitude = list.validatedValue("arLong", expected: "" as AnyObject) as! String
        return obj
    }
    */
    
    class func getUpdatedProfileData(list: Dictionary<String, AnyObject>) -> BGUserInfoModal{
        let obj = BGUserInfoModal()
        obj.firstName = list.validatedValue(pFirstName, expected: "" as AnyObject) as! String
        obj.lastName = list.validatedValue(pLastName, expected: "" as AnyObject) as! String
        obj.artistDescription = list.validatedValue("desc", expected: "" as AnyObject) as! String
        obj.email = list.validatedValue(pemail, expected: "" as AnyObject) as! String
        obj.phone = list.validatedValue("phone_no", expected: "" as AnyObject) as! String
        obj.profileImageUrl = list.validatedValue("artist_pic", expected: "" as AnyObject) as! String
        obj.latitude = list.validatedValue("lat", expected: "" as AnyObject) as! String
        obj.longitude = list.validatedValue("long", expected: "" as AnyObject) as! String
        return obj
    }

    func getSubCategoryList(dict: Dictionary<String, Any>) -> Array<BGUserInfoModal> {
        var subCategoryArrayList = Array<BGUserInfoModal>()
        if let responseArray = dict["gallery"] as? Array<Dictionary<String, AnyObject>> {
            for objDict in responseArray {
                let objModel = getSubCategoryDetails(responseDict: objDict)
                subCategoryArrayList.append(objModel)
            }
        }
        return subCategoryArrayList
    }
    
    func getSubCategoryDetails(responseDict : Dictionary<String, AnyObject>?) -> BGUserInfoModal {
        let objSubCategory = BGUserInfoModal()
        objSubCategory.galImage = responseDict?.validatedValue("galImage", expected: "" as AnyObject) as! String
        objSubCategory.galId = responseDict?.validatedValue("galId", expected: "" as AnyObject) as! String
        objSubCategory.galleryIdArray.append(objSubCategory.galId)
        return objSubCategory
    }
}
