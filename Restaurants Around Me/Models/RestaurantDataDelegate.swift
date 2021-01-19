//
//  RestaurantDataDelegate.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 19/1/21.
//

import Foundation

protocol RestaurantDataDelegate {
    func gotLocationData(locationData: LocationModel)
    func gotListData(restaurantListData: RestaurantListModel)
    func gotDetailData(restaurantDetail: RestaurantModel)
    
    func didFailWithError(error: Error)
    func didFailWithError(error: String)
}

extension RestaurantDataDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didFailWithError(error: String) {
        print(error)
    }
}
