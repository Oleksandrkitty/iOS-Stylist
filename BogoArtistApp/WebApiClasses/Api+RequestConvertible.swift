//
//  Api+RequestConvertible.swift
//  BogoUserApp
//
//  Created by Alejandro Moya on 18/08/2019.
//  Copyright © 2019 Mobiloitte. All rights reserved.
//

import Foundation
import Alamofire


extension Api: URLRequestConvertible {
    
    private static let baseURL = "https://bogo-staging.herokuapp.com/api/v1/"
    
    private func encodeParams(req: URLRequest) throws -> URLRequest {
        switch self {
        case .signup, .client, .clientUpdate:
            return req
        case .services, .schedules, .availabilities, .notifications,
             .favorites, .upcomingBookings, .pastBookings, .nearestServices:
            return try URLEncoding.default.encode(req, with: params)
        case .becomeStylist:
            return try URLEncoding.httpBody.encode(req, with: params)
        default:
            return try JSONEncoding.default.encode(req, with: params)
        }
    }
    
    private func setHeaders(req: inout URLRequest) throws {
        var hasAuth = true
        var isJsonReq = true
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        switch self {
        case .clientUpdate, .becomeStylist:
            isJsonReq = false
        case .signup:
            hasAuth = false
            isJsonReq = false
        case .auth, .forgot:
            hasAuth = false
        default:
            break
        }
        
        if isJsonReq {
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if hasAuth {
            if let token = UserDefaults.standard.string(forKey: kAuthToken) {
                req.addValue(token, forHTTPHeaderField: "Authorization")
            } else {
                throw NSError(domain: "NoTokenAvailable", code: 1, userInfo: [NSLocalizedDescriptionKey: "Please login and try again"])
            }
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Api.baseURL.asURL()
        var req = URLRequest(url: url.appendingPathComponent(path))
        req.httpMethod = method.rawValue
        try setHeaders(req: &req)
        req = try encodeParams(req: req)
        return req
    }
    
}
