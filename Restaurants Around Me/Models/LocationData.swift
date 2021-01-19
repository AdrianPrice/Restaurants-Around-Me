//
//  LocationData.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 19/1/21.
//

import Foundation

struct LocationData: Decodable {
    let location_suggestions: [LocationSuggestions]
    //let success: String
}

struct LocationSuggestions: Decodable {
    let entity_type: String
    let entity_id: Int
}
