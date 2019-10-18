//
//  ServiceHelper.swift
//  MeClub
//
//

import Foundation
import Alamofire
final class PServiceHelper {

       
    
    // Specifying the Headers we need
    class var sharedInstance: PServiceHelper {
        
        struct Static {
            static let instance = PServiceHelper()
        }
        return Static.instance
    }
    
    
    func createRequestToUploadDataWithString(additionalParams : Dictionary<String,Any>,dataContent : Data?,strName : String,strFileName : String,strType : String ,apiName : String, mediaArray : Array<Dictionary<String, AnyObject>>,completion: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void) {
        if !APPDELEGATE.isReachable {
            completion(nil,NSError.init(domain: "Please check your internet connection!", code: 000, userInfo: nil))
            return
        }
        self.showHud()
        let url = webApiBaseURL + apiName + ".json"
        Debug.log("\n\n Request URL  >>>>>>\(url)")
        var headers = HTTPHeaders()
        if UserDefaults.standard.value(forKey: "AccessToken") != nil {
           headers = ["Content-Type" : "multipart/form-data", "access_token": UserDefaults.standard.value(forKey: "AccessToken") as! String]
        } else {
            headers = ["Content-Type" : "multipart/form-data"]
        }
        
        let URL = try! URLRequest(url: url, method: .post, headers: headers)
        
        Alamofire.upload(multipartFormData: { (multipartData) in
            for (key,value) in additionalParams {
                multipartData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            for items in mediaArray {
                
                let data = items[keyMultiPartData] as? Data
                
                if data != nil {
                    multipartData.append(data!, withName:"gallery[]", fileName: items[keyMultiPartFileType] as! String, mimeType: "image/jpg")
                }
            }
            if dataContent != nil {
                multipartData.append(dataContent!, withName:strName, fileName: strFileName, mimeType: strType)
            }
        }, with: URL) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    self.hideHud()
                    completion(response.result.value as AnyObject?, nil)
                }
                break
                
            case .failure(let encodingError):
                completion(nil, encodingError as NSError?)
                self.hideHud()
                break
            }
        }
    }
    
    func showHud() {
        /*DispatchQueue.main.async(execute: {
            var hud = MBProgressHUD(for: APPDELEGATE.window!)
            if hud == nil {
                hud = MBProgressHUD.showAdded(to: APPDELEGATE.window!, animated: true)
            }
            hud?.bezelView.layer.cornerRadius = 8.0
            hud?.bezelView.color = UIColor(red: 222/225.0, green: 222/225.0, blue: 222/225.0, alpha: 222/225.0)
            hud?.margin = 12
            //hud?.activityIndicatorColor = UIColor.white
            hud?.show(animated: true)
        })*/
    }
    func hideHud() {
        
        /*DispatchQueue.main.async(execute: {
            let hud = MBProgressHUD(for: APPDELEGATE.window!)
            hud?.hide(animated: true)
        })*/
        
    }
}
