//
//  BGGalleryInfo.swift
//  BogoArtistApp
//
//

import UIKit

class BGGalleryInfo: NSObject {
    var id              = ""
    var image           : AnyObject!
    var isCorssShown    = false
    var isImageUpdated  = false
    
    class func getGalleryImages(dict: Dictionary<String, Any>) -> [BGGalleryInfo] {
        var imageArray = [BGGalleryInfo]()
        if let responseArray = dict["gallery"] as? Array<Dictionary<String, AnyObject>> {
            for imageDict in responseArray {
                let objGallery = BGGalleryInfo()
                objGallery.id = "\(imageDict.validatedValue("galId", expected: "" as AnyObject))"
                if let image = imageDict["galImage"] as? String {
                    objGallery.image = image as AnyObject
                }
                imageArray.append(objGallery)
            }
        }
        return imageArray
    }
}
