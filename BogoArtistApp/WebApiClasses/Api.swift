//
//  Api.swift
//  BogoUserApp
//
//  Created by Alejandro Moya on 18/07/2019.
//  Copyright © 2019 Mobiloitte. All rights reserved.
//

import Foundation
import Alamofire

enum Api {
    
    case auth(email: String, password: String),
    signup(params: [String: Any]),
    forgot(email: String),
    services(type: Int),
    nearestServices(type: Int, lat: Double, long: Double),
    schedules(params: [String: Any]),
    availabilities(scheduleId: Int),
    client(id: Int),
    clientUpdate(id: Int, params: [String: Any]),
    notifications(params: [String: Any]),
    favorites(clientId: String),
    help(message: String),
    pastBookings(clientId: String),
    upcomingBookings(clientId: String),
    becomeStylist(params: [String: Any]),
    cards(clientId: String),
    deleteCard(id: String)
    
    var path: String {
        switch self {
        case .auth:
            return "authenticate"
        case .signup:
            return "clients/signup"
        case .forgot:
            return "password/forgot"
        case .services:
            return "services"
        case .nearestServices:
            return "services/nearest_services"
        case  .schedules:
            return "schedules"
        case .availabilities:
            return "availabilities"
        case .client(id: let id), .clientUpdate(id: let id, params: _):
            return "clients/\(id)"
        case .notifications:
            return "notifications"
        case .favorites:
            return "favorites"
        case .help:
            return "contacts"
        case .pastBookings:
            return "bookings/past_appointments"
        case .upcomingBookings:
            return "bookings/upcoming_appointments"
        case .becomeStylist:
            return "clients/become_a_stylist"
        case .cards:
            return "cards"
        case .deleteCard(id: let id):
            return "cards/\(id)"
        }
    }
    
    var params: [String: Any] {
        switch self {
        case .signup(params: let params),
             .clientUpdate(id: _, params: let params),
             .schedules(params: let params),
             .notifications(params: let params),
             .becomeStylist(params: let params):
            return params
        case .auth(email: let email, password: let password):
            return ["email": email, "password": password, "role": "client"]
        case .forgot(email: let email):
            return ["email": email]
        case .services(type: let type):
            return ["service_type": type]
        case .nearestServices(type: let type, lat: let lat, long: let long):
            return ["service_type_id": type, "lat": lat, "long": long]
        case .availabilities(scheduleId: let id):
            return ["schedule_id": id]
        case .client, .deleteCard:
            return [:]
        case .favorites(clientId: let id),
             .pastBookings(clientId: let id),
             .upcomingBookings(clientId: let id),
             .cards(clientId: let id):
            return ["client_id": id]
        case .help(message: let message):
            return ["contacts":["message": message]]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .services, .schedules,
             .availabilities, .client, .notifications,
             .favorites, .upcomingBookings, .pastBookings,
            .cards, .nearestServices:
            return .get
        case .clientUpdate:
            return .put
        case .deleteCard:
            return .delete
        default:
            return .post
        }
    }
    
}

