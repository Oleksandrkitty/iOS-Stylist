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
         serviceTypes,
         services(type: Int),
         nearestServices(type: Int, lat: Double, long: Double),

         // schedules
         schedules(params: [String: Any]),
         schedulesByStylist(params: [String: Any]),
         addSchedules(params: [String: Any]),

         availabilities(params: [String: Any]),
         client(id: Int),
         clientUpdate(id: Int, params: [String: Any]),
         notifications(params: [String: Any]),

         // favorites
         favorites(clientId: String),
         addFavorite(params: [String: Any]),
         removeFavorite(id: Int),

         help(message: String),

         // booking
         book(params: [String: Any]),
         booking(id: Int),
         startBooking(id: Int),
         completeBooking(id: Int),
         rejectBooking(id: Int),
         cancelBooking(id: Int),
         pastBookings(clientId: String),
         upcomingBookings,

         // payments
         pay(params: [String: Any]),
         payments(params: [String: Any]),
         stylistsBookedPayments(params: [String: Any]),
         stylistsNextPaydayPayments(params: [String: Any]),

         // reviews
         sendReview(params: [String: Any]),

         // stylists
         stylist(id: Int),
         becomeStylist(clientId: Int, params: [String: Any]),

         cards,
         addCard(params: [String: Any]),
         deleteCard(id: String),
         availableStylists(params: [String: Any]),
         updateMessage(id: String, params: [String: Any]),
         deleteMessage(id: String),

         // messages
         messages(params: [String: Any]),
         message(id: String),
         sendMessage(params: [String: Any])

    var path: String {
        switch self {
        case .auth:
            return "authenticate"
        case .signup:
            return "clients/signup"
        case .forgot:
            return "password/forgot"
        case .serviceTypes:
            return "service_types"
        case .services:
            return "services"
        case .nearestServices:
            return "services/nearest_services"
        case  .schedules, .addSchedules:
            return "schedules"
        case  .schedulesByStylist:
            return "schedules/by_stylist"
        case .availabilities:
            return "availabilities"
        case .client(id: let id), .clientUpdate(id: let id, params: _):
            return "clients/\(id)"
        case .notifications:
            return "notifications"
        case .favorites, .addFavorite:
            return "favorites"
        case .help:
            return "contacts"
        case .book:
            return "bookings"
        case .pastBookings:
            return "bookings/past_appointments"
        case .upcomingBookings:
            return "bookings/upcoming_appointments"
        case .becomeStylist(clientId: let clientId, params: _):
            return "clients/\(clientId)/become_a_stylist"
        case .cards, .addCard:
            return "cards"
        case .deleteCard(id: let id):
            return "cards/\(id)"
        case .removeFavorite(id: let id):
            return "favorites/\(id)"
        case .booking(id: let id):
            return "bookings/\(id)"
        case .stylist(id: let id):
            return "stylists/\(id)"
        case .startBooking(id: let id):
            return "bookings/\(id)/confirm"
        case .completeBooking(id: let id):
            return "bookings/\(id)/complete"
        case .rejectBooking(id: let id):
            return "bookings/\(id)/reject"
        case .cancelBooking(id: let id):
            return "bookings/\(id)"
        case .availableStylists:
            return "stylists/available_stylists"
        case .messages, .sendMessage:
            return "messages"
        case .pay, .payments:
            return "payments"
        case .stylistsBookedPayments:
            return "stylists/booked_payment_data"
        case .stylistsNextPaydayPayments:
            return "stylists/next_payday_payment_data"
        case .sendReview:
            return "reviews"
        case .message(id: let id), .deleteMessage(id: let id), .updateMessage(id: let id, params: _):
            return "messages/\(id)"
        }
    }
    
    var params: [String: Any]? {
        switch self {
        case .signup(params: let params),
             .clientUpdate(id: _, params: let params),
             .updateMessage(id: _, params: let params),
             .schedules(params: let params),
             .schedulesByStylist(params: let params),
             .addSchedules(params: let params),
             .notifications(params: let params),
             .availabilities(params: let params),
             .availableStylists(params: let params),
             .book(params: let params),
             .pay(params: let params),
             .payments(params: let params),
             .stylistsBookedPayments(params: let params),
             .stylistsNextPaydayPayments(params: let params),
             .sendReview(params: let params),
             .addCard(params: let params),
             .addFavorite(params: let params),
             .messages(params: let params),
             .sendMessage(params: let params):
            return params
        case .becomeStylist(clientId: let _, params: let params):
            return params
        case .auth(email: let email, password: let password):
            return ["email": email, "password": password, "role": "stylist"]
        case .forgot(email: let email):
            return ["email": email]
        case .services(type: let type):
            return ["service_type": type]
        case .nearestServices(type: let type, lat: let lat, long: let long):
            return ["service_type_id": type, "lat": lat, "long": long]
        case .favorites(clientId: let id),
             .pastBookings(clientId: let id):
            return ["client_id": id]
        case .help(message: let message):
            return ["contacts":["message": message]]
        case .client, .booking, .deleteCard, .message, .deleteMessage, .cancelBooking, .removeFavorite,
             .serviceTypes, .cards, .upcomingBookings, .startBooking, .completeBooking, .rejectBooking, .stylist:
            return nil
        }
    }

    var method: HTTPMethod {
        switch self {
        case .services, .serviceTypes, .schedules, .schedulesByStylist,
             .availabilities, .client, .stylist, .booking, .notifications,
             .favorites, .upcomingBookings, .pastBookings,
             .cards, .nearestServices, .availableStylists, .messages,
             .payments, .stylistsBookedPayments, .stylistsNextPaydayPayments:
            return .get
        case .clientUpdate, .startBooking, .completeBooking, .rejectBooking:
            return .put
        case .deleteCard, .deleteMessage, .cancelBooking, .removeFavorite:
            return .delete
        default:
            return .post
        }
    }
    
}

