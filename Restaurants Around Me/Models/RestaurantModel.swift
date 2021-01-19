//
//  RestaurantModel.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 18/1/21.
//

import Foundation
import UIKit

struct RestaurantModel: Codable {
    let name: String
    //let description: String
    let website: String
    
    let location: RestaurantLocation
    
    let priceRanking: Int
    lazy var priceRankingInt = Int(priceRanking)
    
    let images: RestaurantImages
    
    let menuURL: String
    
    var ratings: RestaurantRating
    
    init (name: String, website: String, location: RestaurantLocation, priceRanking: Int, images: RestaurantImages, menuURL: String, ratings: RestaurantRating) {
        self.name = name
        //self.description = description
        self.website = website
        self.location = location
        self.priceRanking = priceRanking
        self.images = images
        self.menuURL = menuURL
        self.ratings = ratings
    }
}


struct RestaurantLocation: Codable {
    let address: String
    let latitude: String
    let longitude: String
    
    init (address: String, latitude: String, longitude: String) {
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct RestaurantRating: Codable {
    var rating: String
    lazy var ratingDouble: Double = Double(rating)!
    
    let votes: Int
    //lazy var votesInt: Int = Int(votes)!
    
    init (rating: String, votes: Int) {
        self.rating = rating
        self.votes = votes
    }
}

struct RestaurantImages: Codable {
    let thumbnail: String //Stored as URL
    let featureImage: String //Stored as URL
    
    init (thumbnailURL thumbnail: String, featureImageURL featureImage: String)  {
        self.thumbnail = thumbnail
        self.featureImage = featureImage
    }
}
