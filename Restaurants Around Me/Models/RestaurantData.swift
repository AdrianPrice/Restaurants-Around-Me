//
//  RestaurantData.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 19/1/21.
//

import Foundation

struct RestaurantData: Codable {
    var name: String
    var url: String
    
    var location: Location
    
    var price_range: Int
    
    var thumb: String
    var featured_image: String
    
    var user_rating: Rating
    
    var menu_url: String
}

struct Location: Codable {
    var address: String
    var latitude: String
    var longitude: String
}

struct Rating: Codable {
    var aggregate_rating: String
    var votes: Int
}
