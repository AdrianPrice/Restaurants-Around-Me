//
//  RestaurantListFetcher.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 25/1/21.
//

import Foundation

protocol RestaurantListFetcherDelegate: CanHandleErrors {
    func parseListData(data: Data)
}

class RestaurantListFetcher {
    var delegate: RestaurantListFetcherDelegate?
    
    func fetch (userLocation: LocationModel) {
        if let fetchLink = URL(string: "https://developers.zomato.com/api/v2.1/location_details?entity_id=\(userLocation.cityID!)&entity_type=\(userLocation.groupType!)") {
            var request = URLRequest(url: fetchLink)
            request.httpMethod = "POST"
            request.addValue("d1753bb21685b078e65456592c49e3a8", forHTTPHeaderField: "user-key")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else { print(error!.localizedDescription); return }
                guard let data = data else { self.delegate?.didFailWithError(error: "Empty Data"); return }
                
                self.delegate?.parseListData(data: data) 
            }.resume()
        } else {
            self.delegate?.didFailWithError(error: "Invalid URL: https://developers.zomato.com/api/v2.1/location_details?entity_id=\(userLocation.cityID!)&entity_type=\(userLocation.groupType!)")
        }
    }
}
