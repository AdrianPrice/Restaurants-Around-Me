//
//  RestaurantListPresenter.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 25/1/21.
//

import Foundation

protocol RestaurantListPresenterDelegate: CanHandleErrors {
    func gotListData(listData: RestaurantListModel)
}

class RestaurantListPresenter: RestaurantListFetcherDelegate {
    
    var delegate: RestaurantListPresenterDelegate?
    
    let fetcher = RestaurantListFetcher()
    
    init() {
        self.fetcher.delegate = self
    }
    
    func parseListData(data: Data) {
        let decoder = JSONDecoder()
        var model = RestaurantListModel(nearbyRestaurants: [String]())
        
        do {
            let decodedData = try decoder.decode(RestaurantListData.self, from: data)
            
            let restaurantList = decodedData.nearby_res
            
            model.nearbyRestaurants = restaurantList
            
            delegate?.gotListData(listData: model)
            
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
    
    func fetch (userLocation: LocationModel) {
        fetcher.fetch(userLocation: userLocation)
    }
}
