//
//  EKCommonApiCalls.swift
//  eKinCare
//
//

import UIKit

extension CQUser {
    
    func authenticate(_ hudType: loadingIndicatorType, completionBlock: @escaping (AnyObject?, Error?, Int) -> Void) ->Void {
        
        let paramDict = [
            "mobile" : self.email,
            "password" : self.password,
            "channel_id" : AppUtility.deviceUDID()
        ]
        
        ServiceHelper.request(params: paramDict, method: .post, apiName: kAPINameLogin, hudType: .simple) { (result, error, httpCode) in
            
            if let error = error {
                AlertController.alert(title: error.localizedDescription)
            }
            completionBlock(result, error, httpCode)
        }
    }
}
