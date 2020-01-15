//
//  Api+Networking.swift
//  BogoUserApp
//
//  Created by Alejandro Moya on 02/08/2019.
//  Copyright © 2019 Mobiloitte. All rights reserved.
//

import Foundation
import Alamofire
import PKHUD
import AlamofireObjectMapper
import ObjectMapper

extension Api {
 
    private static func switchNetworkIndicator(show: Bool, useDialog: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = show
        if useDialog {
            if show {
                HUD.show(.progress)
            } else {
                HUD.hide()
            }
        }
    }

    static func requestMappable<T: Mappable>(_ endpoint: Api, showDialog: Bool = true, success: @escaping (T) -> Void, failure: ((Error) -> Void)? = nil) {
        switchNetworkIndicator(show: true, useDialog: showDialog)
        Alamofire.request(endpoint).validate().responseObject { (response: DataResponse<T>) in
            switchNetworkIndicator(show: false, useDialog: showDialog)
            switch response.result {
            case .success(let val):
                success(val)
            case .failure(let error):
                handle(error, failure: failure)
            }
        }
    }
    
    static func requestMappableArray<T: Mappable>(_ endpoint: Api, showDialog: Bool = true, success: @escaping ([T]) -> Void, failure: ((Error) -> Void)? = nil) {
        switchNetworkIndicator(show: true, useDialog: showDialog)
        Alamofire.request(endpoint).validate().responseArray { (response: DataResponse<[T]>) in
            switchNetworkIndicator(show: false, useDialog: showDialog)
            switch response.result {
            case .success(let val):
                success(val)
            case .failure(let error):
                handle(error, failure: failure)
            }
        }
    }
    
    static func requestJSON(_ endpoint: Api, showDialog: Bool = true, success: @escaping (Any) -> Void, failure: ((Error) -> Void)? = nil) {
        switchNetworkIndicator(show: true, useDialog: showDialog)
        let request = Alamofire.request(endpoint)
        request.validate().responseJSON { response in
            switchNetworkIndicator(show: false, useDialog: showDialog)
            handle(response: response, success: success, failure: failure)
        }
    }

    static func upload(_ endpoint: Api, showDialog: Bool = true, success: @escaping (Any) -> Void, failure: ((Error) -> Void)? = nil) {
        switchNetworkIndicator(show: true, useDialog: showDialog)
        Alamofire.upload(multipartFormData: { (formData) in
            for param in endpoint.params ?? [:] {
                if let image = param.value as? UIImage, let imgData = image.jpegData(compressionQuality: 0.7) {
                    formData.append(imgData, withName: param.key, fileName: "avatar.jpg" , mimeType: "image/jpg")
                } else if let data = (param.value as! String).data(using: .utf8) {
                    formData.append(data, withName: param.key)
                }
            }
        }, with: endpoint, encodingCompletion: { (encodingResult) in
            switch encodingResult {
            case .success(request: let req, streamingFromDisk: _, streamFileURL: _):
                req.responseJSON(completionHandler: { (response) in
                    switchNetworkIndicator(show: false, useDialog: showDialog)
                    handle(response: response, success: success, failure: failure)
                })
            case .failure(let error):
                switchNetworkIndicator(show: false, useDialog: showDialog)
                handle(error, failure: failure)
            }
        })
    }
    
    private static func handle<T>(response: DataResponse<T>, success: @escaping (Any) -> Void, failure: ((Error) -> Void)?) {
        switch response.result {
        case .success(let val):
            success(val)
        case .failure(let error):
            handle(error, failure: failure)
        }
    }
    
    private static func handle(_ error: (Error), failure: ((Error) -> Void)?) {
        if let failure = failure {
            failure(error)
        } else {
            AlertController.alert(message: error.localizedDescription)
            debugPrint(error)
        }
    }
    
}
