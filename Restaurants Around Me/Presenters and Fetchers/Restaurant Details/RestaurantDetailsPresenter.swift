//
//  RestaurantDetailsPresenter.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 25/1/21.
//

import Foundation

protocol RestaurantDetailsPresenterDelegate: CanHandleErrors {
    func gotDetailsData(restaurantDetails: RestaurantModel)
}

class RestaurantDetailsPresenter: RestaurantDetailsFetcherDelegate {
    var delegate: RestaurantDetailsPresenterDelegate?
    
    let fetcher = RestaurantDetailsFetcher()
    
    init() {
        self.fetcher.delegate = self
    }
    
    func parseDetailData(data: Data) {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(RestaurantData.self, from: data)
            
            let locationModel = RestaurantLocation(address: decodedData.location.address, latitude: decodedData.location.latitude, longitude: decodedData.location.longitude)
            
            let imageModel = RestaurantImages(thumbnailURL: decodedData.thumb, featureImageURL: decodedData.featured_image)
            
            let ratingModel = RestaurantRating(rating: decodedData.user_rating.aggregate_rating, votes: decodedData.user_rating.votes)
            
            let model = RestaurantModel(name: decodedData.name, website: decodedData.url, location: locationModel, priceRanking: decodedData.price_range, images: imageModel, menuURL: decodedData.menu_url, ratings: ratingModel)
            
            self.delegate?.gotDetailsData(restaurantDetails: model)
            
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
    
    func fetch (restaurantID: String) {
        self.fetcher.fetch(restaurantID: restaurantID)
    }
}
