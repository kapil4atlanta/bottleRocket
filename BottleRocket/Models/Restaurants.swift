//
//  Restaurants.swift
//  BottleRocket
//
//  Created by Kapil Rathan on 3/9/22.
//

import Foundation

struct DataModel: Decodable {
    let restaurants: [Restaurant]?
}

struct Restaurant: Decodable {
    let name: String?
    let backgroundImageURL: String?
    let category: String?
    let contact: RestaurantContact?
    let location: RestaurantLocation?
}

struct RestaurantContact: Decodable {
    let phone, formattedPhone: String?
    let twitter, facebook, facebookUsername, facebookName: String?
}

struct RestaurantLocation: Decodable {
    let address: String
    let crossStreet: String?
    let lat, lng: Double
    let postalCode: String?
    let cc: String?
    let city: String?
    let state: String?
    let country: String?
    let formattedAddress: [String]
}

