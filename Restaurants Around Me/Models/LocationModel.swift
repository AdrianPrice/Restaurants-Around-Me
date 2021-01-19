//
//  LocationModel.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 19/1/21.
//

import Foundation

struct LocationModel: Codable {
    let latitude: String
    let longitude: String
    
    let cityName: String
    
    //These will be added once the location API is called and the id and group type are recieved
    var cityID: String?
    var groupType: String?
    
    init(latitude lat: String, longitude long: String, cityName name: String) {
        self.latitude = lat
        self.longitude = long
        self.cityName = name
        
        self.cityID = nil
        self.groupType = nil
    }
}
